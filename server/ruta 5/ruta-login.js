import express from 'express';
import db from '../db/db.js';
import { comparePassword } from '../f(x)/contrasenias.js';
import { isAuthenticated } from '../middleware/protegerRutas.js';
import { hashPassword } from '../f(x)/contrasenias.js';
import { syncRelationships, syncSingleRelationship } from '../f(x)/relaciones.js';
import bcrypt from 'bcrypt';
import { registrarAccion } from '../middleware/historial.js';
import nodemailer from 'nodemailer';

const router = express.Router();
router.post('/login', async (req, res) => {
    const { correo, contraseña } = req.body;
  
    try {
      db.query('SELECT * FROM usuarios WHERE correo = ?', [correo], async (err, results) => {
        if (err) return res.status(500).json({ error: 'Error del servidor' });
        if (results.length === 0) return res.status(401).json({ error: 'Usuario no encontrado' });
  
        const user = results[0];
        const match = await comparePassword(contraseña, user.contraseña);
  
        if (!match) {
           // Registrar intento fallido de login
          const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
          const fechaHora = new Date().toISOString().slice(0, 19).replace('T', ' ');
          db.query(
            'INSERT INTO historial_acciones (id_usuario, accion, fecha_hora, ip) VALUES (?, ?, ?, ?)',
            [user.id_usuario, 'Intento fallido de login', fechaHora, ip]
          );

          return res.status(401).json({ error: 'Contraseña incorrecta' });
        }
  
        const currentDateTime = new Date().toISOString().slice(0, 19).replace('T', ' ');
  
        const insertLogin = new Promise((resolve, reject) => {
          db.query('INSERT INTO login (id_usuario, fecha_hora) VALUES (?, ?)', [user.id_usuario, currentDateTime], (err) => {
            if (err) reject(err);
            else resolve();
          });
        });
  
        const updateLastConnection = new Promise((resolve, reject) => {
          db.query('UPDATE usuarios SET ultima_conexion = ? WHERE id_usuario = ?', [currentDateTime, user.id_usuario], (err) => {
            if (err) reject(err);
            else resolve();
          });
        });
  
        await Promise.all([insertLogin, updateLastConnection]);
  
        req.session.usuario = {
          id: user.id_usuario,
          correo: user.correo,
          rol: user.rol,
          primer_nombre: user.primer_nombre,
          primer_apellido: user.primer_apellido,
          ultima_conexion: currentDateTime
        };
  
        // Registrar login exitoso
        const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
        db.query(
          'INSERT INTO historial_acciones (id_usuario, accion, fecha_hora, ip) VALUES (?, ?, ?, ?)',
          [user.id_usuario, 'Login exitoso', currentDateTime, ip]
        );

        return res.json({
          rol: user.rol,
          usuario: req.session.usuario
        });
      });
    } catch (error) {
      return res.status(500).json({ error: 'Error del servidor' });
    }
  });
  
  // Logout
  router.post('/logout', (req, res) => {
    // Captura la información del usuario ANTES de destruir la sesión
    const usuarioParaLog = req.session.usuario ? { ...req.session.usuario } : null;

    req.session.destroy((err) => {
        if (err) {
            console.error('Error al destruir la sesión:', err);
            return res.status(500).json({ error: 'Error al cerrar sesión', detalle: err.message });
        }

        // Registrar logout en el historial de acciones si la información del usuario estaba disponible
        if (usuarioParaLog && usuarioParaLog.id) {
            const fechaHora = new Date().toISOString().slice(0, 19).replace('T', ' ');
            const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
            // Usamos db.query directamente porque no estamos en un Promise.all ni necesitamos await aquí
            db.query(
                'INSERT INTO historial_acciones (id_usuario, accion, fecha_hora, ip) VALUES (?, ?, ?, ?)',
                [usuarioParaLog.id, 'Logout', fechaHora, ip],
                (logErr) => {
                    if (logErr) {
                        console.error('Error al registrar logout en historial_acciones:', logErr);
                        // A pesar del error de log, la sesión ya está destruida, así que continuamos
                    }
                }
            );
        }

        // Limpiar la cookie de sesión del lado del cliente
        res.clearCookie('connect.sid');
        // Enviar la respuesta de éxito al cliente
        res.json({ message: 'Sesión cerrada' });
    });
});
  // Obtener usuario logueado
  router.get('/usuario', isAuthenticated, (req, res) => {
    res.json(req.session.usuario);
  });

  router.post('/register', registrarAccion('Registro de nuevo usuario', 'usuarios'), async (req, res) => {
    try {
      const {
        cedula, primerNombre, segundoNombre = null,
        primerApellido, segundoApellido = null,
        correo = null, telefono = null, direccion,
        id_estado, id_ciudad, contraseña, ultima_conexion = null
      } = req.body;
  
      // 📌 Validar campos obligatorios para el registro de login
      if (!cedula || !primerNombre || !primerApellido || !direccion || !id_estado || !id_ciudad || !contraseña) {
        return res.status(400).json({ error: 'Faltan campos obligatorios para el registro de login' });
      }
  
      // 📌 Validar que no exista esa cédula
      db.query('SELECT id_usuario FROM usuarios WHERE cedula = ?', [cedula], (err, rows) => {
        if (err) return res.status(500).json({ error: 'Error al verificar cédula' });
        if (rows.length > 0) return res.status(400).json({ error: 'Cédula ya registrada' });
  
        // 📌 Insertar dirección antes de registrar el usuario
        db.query('INSERT INTO direccion (direccion, id_ciudad, id_estado) VALUES (?, ?, ?)', 
          [direccion, id_ciudad, id_estado], async (err, dirResult) => {
            if (err) return res.status(500).json({ error: 'Error al insertar dirección' });
  
            const id_direccion = dirResult.insertId;
            const hashed = await hashPassword(contraseña); // La contraseña es obligatoria aquí
  
            // 📌 Asignar valores por defecto para el registro de login
            const rol = 'pendiente';       // por defecto
            const id_nivel = 4;            // nivel "pendiente"
  
            const sql = `
              INSERT INTO usuarios (
                cedula, primer_nombre, segundo_nombre,
                primer_apellido, segundo_apellido, telefono,
                correo, contraseña, rol, id_direccion, id_nivel, ultima_conexion
              ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `;
  
            const values = [
              cedula, primerNombre, segundoNombre,
              primerApellido, segundoApellido, telefono,
              correo, hashed, rol, id_direccion, id_nivel, ultima_conexion
            ];
  
            db.query(sql, values, (err, userResult) => {
              if (err) {
                console.error('Error insertando usuario:', err);
                return res.status(500).json({ error: 'Error al registrar usuario' });
              }
  
              const id_usuario = userResult.insertId;
  
              // 📌 Registrar la notificación para la administradora (id_admin = 1)
              db.query(`
                INSERT INTO notificaciones (id_usuario, id_admin, mensaje, estado) 
                VALUES (?, ?, 'Usuario por confirmación', 'pendiente')
              `, [id_usuario, 1], (err) => {
                if (err) console.error("Error creando notificación:", err);
              });
              
            const responseData = {
          success: true,
          message: 'Usuario registrado. Espera aprobación del administrador.',
          usuario: { 
            id_usuario: id_usuario, 
            cedula: cedula 
          }
        };


              return res.json(responseData);
            });
          }
        );
      });
    } catch (error) {
      console.error('Catch /register:', error);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
  });
// --- COMIENZO DE LAS FUNCIONES DE UTILIDAD (DEBEN ESTAR EN TU BACKEND) ---

// Función para convertir db.query en una Promesa
// Esto es necesario para usar async/await con mysql2 basado en callbacks.
const queryPromise = (sql, values) => {
    return new Promise((resolve, reject) => {
        // Asegúrate de que 'db' sea tu objeto de conexión a la base de datos mysql2
        // Ejemplo: db.query(...)
        db.query(sql, values, (err, result) => {
            if (err) {
                console.error("Error en queryPromise:", err); // Log de error aquí también
                return reject(err);
            }
            resolve(result);
        });
    });
};

// Funciones para manejar transacciones con Promesas (si las usas)
const beginTransactionPromise = () => {
    return new Promise((resolve, reject) => {
        db.beginTransaction(err => {
            if (err) {
                console.error("Error al iniciar transacción:", err);
                return reject(err);
            }
            resolve();
        });
    });
};

const commitPromise = () => {
    return new Promise((resolve, reject) => {
        db.commit(err => {
            if (err) {
                console.error("Error al hacer commit de transacción:", err);
                return reject(err);
            }
            resolve();
        });
    });
};

const rollbackPromise = () => {
    return new Promise((resolve, reject) => {
        db.rollback(() => {
            console.warn('Transacción revertida.');
            resolve(); // Siempre resuelve para no encadenar errores de rollback
        });
    });
};

// --- FIN DE LAS FUNCIONES DE UTILIDAD ---
  // Esta es una api para terminar el registro de un usuario (asignar rol, secciones, etc.)
router.post('/asignar-usuario', isAuthenticated, registrarAccion('Asignación de rol a usuario', 'usuarios'), (req, res) => {
    try {
        const { id_usuario, rol, secciones = [], cursos = [], materias = [], periodos = [] } = req.body;

        const niveles = { estudiante: 1, admin: 2, profesor: 3 };
        const id_nivel = niveles[rol] || 4; // 4 para "pendiente" o un valor por defecto si el rol no coincide

        console.log(`[ASIGNAR-USUARIO] INICIO - Recibido: id_usuario=${id_usuario}, rol=${rol}, secciones=${JSON.stringify(secciones)}, cursos=${JSON.stringify(cursos)}, materias (id_materia_periodo)=${JSON.stringify(materias)}, periodos=${JSON.stringify(periodos)}`);

        // Paso 1: Actualizar el rol principal del usuario.
        queryPromise('UPDATE usuarios SET rol = ?, id_nivel = ? WHERE id_usuario = ?', [rol, id_nivel, id_usuario])
            .then(async (result) => { // <-- Este callback ahora es async
                console.log(`[ASIGNAR-USUARIO] Rol de usuario ${id_usuario} actualizado a ${rol}.`);

                // Función para continuar con las asignaciones específicas del rol
                const continuarAsignaciones = async () => { // <-- Esta función DEBE ser async
                    const directAssignmentPromises = []; // Para secciones, cursos, periodos (inserciones directas)

                    if (rol === 'estudiante' || rol === 'profesor') {
                        // Asignar secciones al usuario
                        if (secciones && secciones.length > 0) {
                            const seccionValues = secciones.map(id_sec => [id_usuario, id_sec]);
                            console.log(`[ASIGNAR-USUARIO] Preparando inserción en usuario_seccion: ${JSON.stringify(seccionValues)}`);
                            directAssignmentPromises.push(queryPromise('INSERT INTO usuario_seccion (id_usuario, id_seccion) VALUES ?', [seccionValues]));
                        }

                        // Asignar cursos al usuario
                        if (cursos && cursos.length > 0) {
                            const currentDateTime = new Date().toISOString().slice(0, 19).replace('T', ' ');
                            const cursoValues = cursos.map(id_cur => [id_usuario, id_cur, currentDateTime]);
                            console.log(`[ASIGNAR-USUARIO] Preparando inserción en usuario_cursos: ${JSON.stringify(cursoValues)}`);
                            directAssignmentPromises.push(queryPromise('INSERT INTO usuario_cursos (id_usuario, id_curso, fecha_inscripcion) VALUES ?', [cursoValues]));
                        }

                        // Asignar periodos al usuario
                        if (periodos && periodos.length > 0) {
                            const periodoValues = periodos.map(id_per => [id_usuario, id_per]);
                            console.log(`[ASIGNAR-USUARIO] Preparando inserción en usuario_periodo: ${JSON.stringify(periodoValues)}`);
                            directAssignmentPromises.push(queryPromise('INSERT INTO usuario_periodo (id_usuario, id_periodo) VALUES ?', [periodoValues]));
                        }

                        // MODIFICACIÓN CLAVE: Asignar materias llamando a las APIs específicas (como en profesores/register)
                        if (materias && materias.length > 0) {
                            console.log(`[ASIGNAR-USUARIO] Procesando ${materias.length} materias (id_materia_periodo) para llamadas a API.`);
                            for (const id_materia_periodo of materias) {
                                console.log(`[ASIGNAR-USUARIO] Materia a procesar: id_materia_periodo = ${id_materia_periodo}`);
                                try {
                                    // 1. Obtener id_materia y id_periodo de la tabla materias_periodo
                                    const mpDetails = await queryPromise('SELECT id_materia, id_periodo FROM materias_periodo WHERE id_materia_periodo = ?', [id_materia_periodo]);

                                    if (mpDetails.length === 0) {
                                        console.warn(`[ASIGNAR-USUARIO] WARN: No se encontraron detalles de materia/periodo para id_materia_periodo: ${id_materia_periodo}. Saltando asignación de materia.`);
                                        continue; // Saltar esta asignación si no se encuentran los detalles
                                    }
                                    const { id_materia, id_periodo } = mpDetails[0];
                                    console.log(`[ASIGNAR-USUARIO] Extraído de materias_periodo: id_materia=${id_materia}, id_periodo=${id_periodo} para id_materia_periodo=${id_materia_periodo}`);

                                    let apiEndpoint;
                                    let bodyData;

                                    if (rol === 'estudiante') {
                                        apiEndpoint = `/api/materias-academicas/${id_materia}/asignar-estudiantes`;
                                        bodyData = { estudiantes: [id_usuario], id_periodo: id_periodo };
                                        console.log(`[ASIGNAR-USUARIO] Rol es ESTUDIANTE. Llamando a: ${apiEndpoint}`);
                                    } else if (rol === 'profesor') {
                                        apiEndpoint = `/api/materias-academicas/${id_materia}/asignar-profesor`;
                                        bodyData = { profesores: [id_usuario], id_periodo: id_periodo };
                                        console.log(`[ASIGNAR-USUARIO] Rol es PROFESOR. Llamando a: ${apiEndpoint}`);
                                    } else {
                                        console.warn(`[ASIGNAR-USUARIO] WARN: Rol desconocido '${rol}' para asignación de materia. Saltando.`);
                                        continue;
                                    }

                                    console.log(`[ASIGNAR-USUARIO] Realizando llamada interna a ${apiEndpoint} con body: ${JSON.stringify(bodyData)}`);
                                    const assignResponse = await fetch(`http://localhost:3001${apiEndpoint}`, {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/json' },
                                        // IMPORTANTE: Si tus APIs de asignación requieren autenticación (ej. token en header),
                                        // deberías incluirlo aquí. 'credentials: include' no funcionará para S2S.
                                        // Por ahora, asumimos que no es estrictamente necesario para llamadas internas o se maneja de otra forma.
                                        body: JSON.stringify(bodyData)
                                    });

                                    let assignData;
                                    try {
                                        assignData = await assignResponse.json();
                                    } catch (jsonError) {
                                        const textResponse = await assignResponse.text();
                                        console.error(`[ASIGNAR-USUARIO] ERROR: No se pudo parsear JSON de la respuesta de ${apiEndpoint}. Respuesta: ${textResponse}`, jsonError);
                                        throw new Error(`Respuesta inválida de la API de asignación: ${textResponse.substring(0, 100)}...`);
                                    }


                                    if (!assignResponse.ok) {
                                        console.error(`[ASIGNAR-USUARIO] ERROR: Fallo en la llamada interna a ${apiEndpoint}:`, assignData.error || assignData.detalle || 'Error desconocido');
                                        throw new Error(`Error al asignar ${rol} a materia ${id_materia} (periodo ${id_periodo}): ${assignData.error || assignData.detalle || 'Error desconocido'}`);
                                    }
                                    console.log(`[ASIGNAR-USUARIO] ÉXITO: ${rol} ${id_usuario} asignado a materia ${id_materia} (periodo ${id_periodo}) exitosamente a través de API.`);

                                } catch (fetchError) {
                                    console.error(`[ASIGNAR-USUARIO] ERROR: Fallo al procesar asignación de materia ${id_materia_periodo}:`, fetchError);
                                    // Propagar el error para que el catch principal lo maneje
                                    return Promise.reject(fetchError);
                                }
                            }
                        } else {
                            console.log('[ASIGNAR-USUARIO] No hay materias para asignar.');
                        }
                    } else {
                        console.log(`[ASIGNAR-USUARIO] Rol '${rol}' no requiere asignaciones académicas detalladas.`);
                    }


                    try {
                        console.log(`[ASIGNAR-USUARIO] Esperando que las promesas de asignación directa (${directAssignmentPromises.length}) se resuelvan...`);
                        await Promise.all(directAssignmentPromises); // Esperar a que las promesas de asignación directa se resuelvan
                        console.log('[ASIGNAR-USUARIO] Todas las asignaciones académicas directas completadas.');

                        // Actualizar notificación a "procesado" (esto siempre se hace, independientemente del rol)
                        queryPromise('UPDATE notificaciones SET estado = "procesado" WHERE id_usuario = ?', [id_usuario])
                            .then(() => console.log(`[ASIGNAR-USUARIO] Notificación para usuario ${id_usuario} actualizada a "procesado".`))
                            .catch(err => console.error('[ASIGNAR-USUARIO] Error actualizando notificación:', err)); // Manejar error de forma independiente

                        // Finalmente, enviar la respuesta de éxito
                        res.status(200).json({ message: 'Usuario asignado y registrado correctamente.' });
                    } catch (assignmentError) {
                        console.error('[ASIGNAR-USUARIO] ERROR: Fallo en una de las asignaciones académicas (Promise.all):', assignmentError);
                        res.status(500).json({ error: 'Error al asignar detalles académicos al usuario.', detalle: assignmentError.message });
                    }
                };

                // Paso 2: Insertar el usuario en la tabla específica del rol (estudiantes, profesores, administradores)
                if (rol === 'estudiante') {
                    console.log(`[ASIGNAR-USUARIO] Insertando usuario ${id_usuario} en tabla 'estudiantes'.`);
                    queryPromise('INSERT INTO estudiantes (id_usuario) VALUES (?)', [id_usuario])
                        .catch(err => console.error('[ASIGNAR-USUARIO] Error insertando en la tabla de estudiantes:', err))
                        .finally(() => continuarAsignaciones());
                } else if (rol === 'profesor') {
                    console.log(`[ASIGNAR-USUARIO] Insertando usuario ${id_usuario} en tabla 'profesores'.`);
                    queryPromise('INSERT INTO profesores (id_usuario) VALUES (?)', [id_usuario])
                        .catch(err => console.error('[ASIGNAR-USUARIO] Error insertando en la tabla de profesores:', err))
                        .finally(() => continuarAsignaciones());
                } else if (rol === 'admin') {
                    console.log(`[ASIGNAR-USUARIO] Insertando usuario ${id_usuario} en tabla 'usuario_administradores'.`);
                    queryPromise('INSERT INTO usuario_administradores (id_usuario) VALUES (?)', [id_usuario])
                        .catch(err => console.error('[ASIGNAR-USUARIO] Error insertando en la tabla de administradores:', err))
                        .finally(() => continuarAsignaciones());
                } else {
                    console.log(`[ASIGNAR-USUARIO] Rol '${rol}' no requiere inserción en tabla específica. Continuando asignaciones.`);
                    continuarAsignaciones();
                }
            })
            .catch(err => { // Captura errores de la actualización inicial del rol
                console.error('[ASIGNAR-USUARIO] ERROR: Fallo al actualizar el rol del usuario (promesa inicial):', err);
                return res.status(500).json({ error: 'Error asignando el rol al usuario.', detalle: err.message });
            });
    } catch (error) {
        console.error('[ASIGNAR-USUARIO] ERROR: General en /asignar-usuario (catch principal):', error);
        res.status(500).json({ error: 'Error interno del servidor.', detalle: error.message });
    }
});
  router.get('/me', (req, res) => {
  if (req.session && req.session.usuario && req.session.usuario.id) {
    res.json({ id_usuario: req.session.usuario.id });
  } else {
    res.json({ id_usuario: null });
  }
});

router.get('/usuarios/:id', (req, res) => {
    const { id } = req.params;

    if (!id) {
        return res.status(400).json({ error: 'ID de usuario no proporcionado.' });
    }

    // Consulta principal para obtener datos del usuario y su dirección, ciudad, estado, y ahora el icono de perfil.
    const sql = `
      SELECT
          u.id_usuario, u.cedula, u.primer_nombre, u.segundo_nombre,
          u.primer_apellido, u.segundo_apellido, u.telefono, u.correo AS correo_electronico,
          u.rol, u.estado, u.ultima_conexion,
          d.direccion,
          c.ciudad,
          e.estados AS estado_residencia,
          u.profile_icon_class  /* ¡NUEVA COLUMNA AÑADIDA! */
      FROM usuarios u
      LEFT JOIN direccion d ON u.id_direccion = d.id_direccion
      LEFT JOIN ciudades c ON d.id_ciudad = c.id_ciudad
      LEFT JOIN estados e ON d.id_estado = e.id_estado
      WHERE u.id_usuario = ?;
    `;

    db.query(sql, [id], (err, results) => {
      if (err) {
        console.error('Error al obtener el perfil del usuario:', err);
        return res.status(500).json({ error: 'Error al obtener el perfil del usuario', detalle: err.message });
      }

      if (results.length === 0) {
        return res.status(404).json({ error: 'Usuario no encontrado.' });
      }

      const user = results[0];
      // Se elimina la lógica de obtener cursos asociados al usuario (`usuario_cursos`)
      // de esta API de perfil, ya que esta información no es relevante para la visualización del perfil
      // y se gestiona en otros contextos académicos.
      res.json(user);
    });
});
  
  /**
   * @route PUT /api/usuarios/:id
   * @description Actualiza el perfil de un usuario existente.
   * Permite actualizar datos personales, dirección y contraseña.
   * @param {number} req.params.id - ID del usuario a actualizar.
   * @returns {json} Mensaje de éxito o error.
   */
router.put('/usuarios/:id',isAuthenticated,registrarAccion('Actualización de perfil', 'usuarios'), async (req, res) => {
    const { id } = req.params;
    const {
      primer_nombre,
      segundo_nombre,
      primer_apellido,
      segundo_apellido,
      correo_electronico,
      direccion,
      old_contrasena, // Contraseña actual proporcionada por el usuario
      contrasena,     // Nueva contraseña (si se va a cambiar)
      profile_icon_class // Clase del icono de perfil
    } = req.body;
 
    // **IMPORTANTE PARA DEPURACIÓN**: Log del cuerpo de la solicitud
    console.log('Backend - req.body recibido para PUT /usuarios/:id:', req.body);

    try {
      let newHashedPassword = null;
 
      // Lógica para cambiar la contraseña
      if (contrasena) { // Si se ha proporcionado una nueva contraseña
        // 1. Obtener la contraseña hasheada actual del usuario desde la BD
        const [userRows] = await db.promise().query('SELECT contraseña FROM usuarios WHERE id_usuario = ?', [id]);
        
        if (userRows.length === 0) {
          return res.status(404).json({ error: 'Usuario no encontrado.' });
        }
        const storedHashedPassword = userRows[0].contraseña;
 
        // 2. Verificar si se proporcionó la contraseña actual y si coincide
        if (!old_contrasena || !(await bcrypt.compare(old_contrasena, storedHashedPassword))) {
          return res.status(401).json({ error: 'La contraseña actual es incorrecta. No se pudo actualizar la contraseña.' });
        }
 
        // 3. Hashear la nueva contraseña
        newHashedPassword = await bcrypt.hash(contrasena, 10);
      }
 
      // Obtener el id_direccion del usuario para actualizar su dirección
      const [addressRows] = await db.promise().query('SELECT id_direccion FROM usuarios WHERE id_usuario = ?', [id]);
      
      if (addressRows.length === 0) {
        // Esto no debería ocurrir si el usuario existe, pero es una validación
        return res.status(404).json({ error: 'Usuario no encontrado para actualizar dirección.' });
      }
      const id_direccion = addressRows[0].id_direccion;
 
      // Actualizar la tabla 'direccion' si se proporcionó la dirección
      if (direccion) {
        await db.promise().query(
          'UPDATE direccion SET direccion = ? WHERE id_direccion = ?',
          [direccion, id_direccion]
        );
      }
 
      // Construir la consulta de actualización para la tabla 'usuarios'
      let userUpdateSql = `
        UPDATE usuarios 
        SET primer_nombre = ?, segundo_nombre = ?, primer_apellido = ?, segundo_apellido = ?, correo = ?
      `;
      let userUpdateParams = [
        primer_nombre,
        segundo_nombre,
        primer_apellido,
        segundo_apellido,
        correo_electronico
      ];
 
      // Si se generó un nuevo hash de contraseña, añadirlo a la consulta
      if (newHashedPassword) {
        userUpdateSql += `, contraseña = ?`;
        userUpdateParams.push(newHashedPassword);
      }

      // Si se proporcionó profile_icon_class, añadirlo a la consulta
      if (profile_icon_class) {
        userUpdateSql += `, profile_icon_class = ?`;
        userUpdateParams.push(profile_icon_class);
      }
 
      userUpdateSql += ` WHERE id_usuario = ?`;
      userUpdateParams.push(id);
 
      const [userUpdateResult] = await db.promise().query(userUpdateSql, userUpdateParams);
 
      if (userUpdateResult.affectedRows === 0) {
        // Si affectedRows es 0, podría significar que no hubo cambios o el ID no existe
        return res.status(200).json({ message: 'Perfil actualizado exitosamente (sin cambios en los datos proporcionados).' });
      }
 
      res.json({ message: 'Perfil actualizado exitosamente.' });
 
    } catch (error) {
      console.error('Error al actualizar perfil:', error);
      // Si el error es por una contraseña incorrecta, ya se maneja con 401.
      // Otros errores (ej. DB, hash) se devolverán como 500.
      res.status(500).json({ error: 'Ocurrió un error al actualizar el perfil.', detalle: error.message });
    }
});



router.post('/solicitar-codigo-recuperacion', async (req, res) => {
    const { correo } = req.body;

    if (!correo) {
        return res.status(400).json({ error: 'El correo electrónico es obligatorio.' });
    }

    try {
        // 1. Verificar si el correo existe en la tabla de usuarios
        const [userResults] = await db.promise().query('SELECT id_usuario FROM usuarios WHERE correo = ?', [correo]);

        if (userResults.length === 0) {
            // No se debe indicar al atacante si el correo existe o no por seguridad
            // Se envía un mensaje genérico de éxito para no dar pistas
            console.warn(`Intento de recuperación de contraseña para correo no registrado: ${correo}`);
            return res.json({ message: 'Si el correo electrónico está registrado, se enviará un código de recuperación.' });
        }

        // 2. Generar un código de 6 dígitos
        const recoveryCode = Math.floor(100000 + Math.random() * 900000).toString(); // Código numérico de 6 dígitos
        const expirationTime = new Date(Date.now() + 15 * 60 * 1000); // 15 minutos de validez

        // 3. Invalidar códigos anteriores para este correo antes de insertar uno nuevo
        await db.promise().query(
            'UPDATE codigos_recuperacion SET usado = TRUE WHERE correo = ? AND usado = FALSE AND expiracion > NOW()',
            [correo]
        );

        // 4. Guardar el nuevo código en la base de datos
        await db.promise().query(
            'INSERT INTO codigos_recuperacion (correo, codigo, expiracion) VALUES (?, ?, ?)',
            [correo, recoveryCode, expirationTime]
        );

        // 5. Configurar el transporter de Nodemailer (REEMPLAZAR CON TUS CREDENCIALES REALES)
        // Utiliza variables de entorno para la seguridad de tus credenciales
        const transporter = nodemailer.createTransport({ 
            service: 'gmail', // Puedes cambiarlo a 'hotmail', 'outlook', o un host SMTP específico
            host: 'smtp.gmail.com',
            port: 465,
            secure: true,
            auth: {
                user: 'andislopez777@gmail.com', // ⚠️ REEMPLAZA CON TU CORREO ELECTRÓNICO
                pass: 'hlfw cfyh ywiu jdzh', // ⚠️ REEMPLAZA CON TU CONTRASEÑA O CONTRASEÑA DE APLICACIÓN (PARA GMAIL)
            }
        });

        // Opciones del correo
        const mailOptions = {
            from: 'andislopez777@gmail.com', // Debe coincidir con el 'user' del transporter
            to: correo,
            subject: 'Código de recuperación de contraseña GLLR',
            text: `Tu código de recuperación es: ${recoveryCode}\nEste código expirará en 15 minutos.`,
            html: `<p>Tu código de recuperación es: <strong>${recoveryCode}</strong></p><p>Este código expirará en 15 minutos.</p><p>Si no solicitaste esto, puedes ignorar este correo.</p>`
        };

        // Enviar el correo
        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.error('Error enviando correo con Nodemailer:', error);
                // Aquí podrías decidir enviar un error al cliente o simplemente loguearlo
                // Si el error de envío de correo no es crítico para el flujo, puedes continuar
                // y dejar que el cliente asuma que el correo fue enviado (por seguridad).
            } else {
                console.log('Correo enviado: ' + info.response);
            }
        });

        res.json({ message: 'Código de recuperación enviado exitosamente.' });

    } catch (error) {
        console.error('Error al solicitar código de recuperación:', error);
        res.status(500).json({ error: 'Error interno del servidor al solicitar el código.' });
    }
});

/**
 * @route POST /restablecer-contrasena
 * @description Verifica el código de recuperación y actualiza la contraseña del usuario.
 * @param {string} req.body.correo - Correo electrónico del usuario.
 * @param {string} req.body.codigo - Código de verificación recibido.
 * @param {string} req.body.nuevaContrasena - Nueva contraseña del usuario.
 * @returns {json} Mensaje de éxito o error.
 */
router.post('/restablecer-contrasena', async (req, res) => {
    const { correo, codigo, nuevaContrasena } = req.body;

    if (!correo || !codigo || !nuevaContrasena) {
        return res.status(400).json({ error: 'Faltan campos obligatorios (correo, código o nueva contraseña).' });
    }

    try {
        // 1. Buscar el código de recuperación más reciente para el correo, que no esté usado y no haya expirado.
        const [codeResults] = await db.promise().query(
            'SELECT * FROM codigos_recuperacion WHERE correo = ? AND usado = FALSE AND expiracion > NOW() ORDER BY created_at DESC LIMIT 1',
            [correo]
        );

        const storedCode = codeResults[0];

        if (!storedCode || storedCode.codigo !== codigo) {
            // Por seguridad, un mensaje genérico para no dar pistas sobre códigos existentes
            return res.status(400).json({ error: 'Código de verificación inválido o expirado.' });
        }

        // 2. Hashear la nueva contraseña
        const hashedNewPassword = await bcrypt.hash(nuevaContrasena, 10);

        // 3. Actualizar la contraseña del usuario en la tabla 'usuarios'
        const [updateUserResult] = await db.promise().query(
            'UPDATE usuarios SET contraseña = ? WHERE correo = ?',
            [hashedNewPassword, correo]
        );

        if (updateUserResult.affectedRows === 0) {
            return res.status(500).json({ error: 'No se pudo actualizar la contraseña. Usuario no encontrado o sin cambios.' });
        }

        // 4. Marcar el código de recuperación como usado para que no se pueda reutilizar
        await db.promise().query(
            'UPDATE codigos_recuperacion SET usado = TRUE WHERE id = ?',
            [storedCode.id]
        );

        res.json({ message: 'Contraseña restablecida exitosamente.' });

    } catch (error) {
        console.error('Error al restablecer contraseña:', error);
        res.status(500).json({ error: 'Error interno del servidor al restablecer la contraseña.' });
    }
});
export default router;
