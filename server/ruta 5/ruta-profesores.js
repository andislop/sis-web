import express from 'express';
import db from '../db/db.js'; // Ajusta esta ruta si es necesario
import { isAuthenticated } from '../middleware/protegerRutas.js'; // Ajusta esta ruta si es necesario
import { hashPassword, comparePassword } from '../f(x)/contrasenias.js'; // Ajusta esta ruta si es necesario
import { syncRelationships, syncSingleRelationship } from '../f(x)/relaciones.js'; // Ajusta esta ruta si es necesario
import { registrarAccion } from '../middleware/historial.js';

const router = express.Router();

router.get('/profesores', async (req, res) => {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 5;
    // NUEVO: Captura el término de búsqueda de la URL
    const searchTerm = req.query.search ? req.query.search.toLowerCase() : '';
    const offset = (page - 1) * limit;

    try {
        let baseWhereClause = `WHERE u.rol = 'profesor'`;
        let countWhereClause = `WHERE rol = 'profesor'`; // Para las consultas COUNT que no usan JOIN
        let queryParams = []; // Parámetros para las consultas SQL

        // Si hay un término de búsqueda, añadirlo a la cláusula WHERE
        if (searchTerm) {
            // Se busca en primer_nombre O primer_apellido (o ambos)
            baseWhereClause += ` AND (LOWER(u.primer_nombre) LIKE ? OR LOWER(u.primer_apellido) LIKE ?)`;
            countWhereClause += ` AND (LOWER(primer_nombre) LIKE ? OR LOWER(primer_apellido) LIKE ?)`;
            queryParams.push(`%${searchTerm}%`, `%${searchTerm}%`);
        }

        // 1️⃣ Consulta para el total de profesores (con o sin filtro de búsqueda)
        const [totalProfesores] = await db.promise().query(
            `SELECT COUNT(*) AS total FROM usuarios ${countWhereClause};`,
            queryParams
        );
        const totalCount = totalProfesores[0].total;

        // 2️⃣ Consulta para el total de profesores activos (con o sin filtro de búsqueda)
        const [ProfesoresActivos] = await db.promise().query(
            `SELECT COUNT(*) AS active FROM usuarios ${countWhereClause} AND estado = 1;`,
            queryParams
        );
        const activeCount = ProfesoresActivos[0].active;

        // 3️⃣ Consulta para el total de profesores inactivos (con o sin filtro de búsqueda)
        const [ProfesoresInactivos] = await db.promise().query(
            `SELECT COUNT(*) AS inactive FROM usuarios ${countWhereClause} AND estado = 0;`,
            queryParams
        );
        const inactiveCount = ProfesoresInactivos[0].inactive;

        const totalPages = Math.ceil(totalCount / limit);

        // 4️⃣ Consulta optimizada para obtener los profesores con todos los detalles
        const profesoresQuery = `
            SELECT
                u.id_usuario,
                u.cedula,
                u.primer_nombre,
                u.segundo_nombre,
                u.primer_apellido,
                u.segundo_apellido,
                u.correo,
                u.telefono,
                d.direccion AS direccion,
                u.estado AS estado,
                u.ultima_conexion,
                IFNULL(GROUP_CONCAT(DISTINCT p.periodo ORDER BY p.periodo ASC), 'N/A') AS periodoAcademicoNames,
                IFNULL(GROUP_CONCAT(DISTINCT up.id_periodo ORDER BY up.id_periodo ASC), '') AS periodoAcademicoIds,
                IFNULL(GROUP_CONCAT(DISTINCT c.curso ORDER BY c.curso ASC), '') AS cursosNames,
                IFNULL(GROUP_CONCAT(DISTINCT uc.id_curso ORDER BY uc.id_curso ASC), '') AS cursosIds,
                IFNULL(GROUP_CONCAT(DISTINCT m.materia ORDER BY m.materia ASC), '') AS materiasNames,
                IFNULL(GROUP_CONCAT(DISTINCT um.id_materia ORDER BY um.id_materia ASC), '') AS materiasIds,
                IFNULL(GROUP_CONCAT(DISTINCT s.seccion ORDER BY s.seccion ASC), '') AS seccionNames,
                IFNULL(GROUP_CONCAT(DISTINCT us.id_seccion ORDER BY us.id_seccion ASC), '') AS seccionIds
            FROM
                usuarios u
            LEFT JOIN
                usuario_periodo up ON u.id_usuario = up.id_usuario
            LEFT JOIN
                periodo p ON up.id_periodo = p.id_periodo
            LEFT JOIN
                usuario_cursos uc ON u.id_usuario = uc.id_usuario
            LEFT JOIN
                cursos c ON uc.id_curso = c.id_curso
            LEFT JOIN
                usuario_materias um ON u.id_usuario = um.id_usuario
            LEFT JOIN
                materias m ON um.id_materia = m.id_materia
            LEFT JOIN
                usuario_seccion us ON u.id_usuario = us.id_usuario
            LEFT JOIN
                seccion s ON us.id_seccion = s.id_seccion
            LEFT JOIN
                direccion d ON u.id_direccion = d.id_direccion
            ${baseWhereClause}
            GROUP BY
                u.id_usuario
            ORDER BY
                u.primer_apellido ASC
            LIMIT ? OFFSET ?;
        `;

        // 🏆 Ejecutar la consulta y procesar los datos
        // Asegúrate de que los parámetros para LIMIT y OFFSET estén al final
        const [profesores] = await db.promise().query(
            profesoresQuery,
            [...queryParams, parseInt(limit), offset] // Añadir los parámetros de paginación al final
        );

        res.json({
            profesores: profesores,
            totalCount,
            activeCount,
            inactiveCount,
            totalPages,
            currentPage: page
        });

    } catch (error) {
        console.error("❌ Error al obtener profesores:", error);
        res.status(500).json({ error: "Error al cargar profesores", detalle: error.message });
    }
});


router.get('/profesores/papelera', async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 5;
  const offset = (page - 1) * limit;

  try {
    const [TotalProfesores] = await db.promise().query('SELECT COUNT(*) AS total FROM usuarios WHERE rol = "profesor" AND estado = 0;');
    const totalCount = TotalProfesores[0].total;

    const totalPages = Math.ceil(totalCount / limit);

    const profesoresQuery = `
      SELECT
          u.id_usuario,
          u.cedula,
          u.primer_nombre,
          u.segundo_nombre,
          u.primer_apellido,
          u.segundo_apellido,
          u.correo,
          u.telefono,
          d.direccion AS direccion,
          u.estado AS estado,
          u.ultima_conexion,
          -- Modificación aquí para asegurar que 'periodoAcademicoNames' sea siempre el nombre del periodo o 'N/A'
          IFNULL(GROUP_CONCAT(DISTINCT p.periodo ORDER BY p.periodo ASC), 'N/A') AS periodoAcademicoNames,
          IFNULL(GROUP_CONCAT(DISTINCT up.id_periodo ORDER BY up.id_periodo ASC), '') AS periodoAcademicoIds,
          IFNULL(GROUP_CONCAT(DISTINCT c.curso ORDER BY c.curso ASC), '') AS cursosNames,
          IFNULL(GROUP_CONCAT(DISTINCT uc.id_curso ORDER BY uc.id_curso ASC), '') AS cursosIds,
          IFNULL(GROUP_CONCAT(DISTINCT m.materia ORDER BY m.materia ASC), '') AS materiasNames,
          IFNULL(GROUP_CONCAT(DISTINCT um.id_materia ORDER BY um.id_materia ASC), '') AS materiasIds,
          IFNULL(GROUP_CONCAT(DISTINCT s.seccion ORDER BY s.seccion ASC), '') AS seccionNames,
          IFNULL(GROUP_CONCAT(DISTINCT us.id_seccion ORDER BY us.id_seccion ASC), '') AS seccionIds
      FROM
          usuarios u
      LEFT JOIN
          usuario_periodo up ON u.id_usuario = up.id_usuario
      LEFT JOIN
          periodo p ON up.id_periodo = p.id_periodo
      LEFT JOIN
          usuario_cursos uc ON u.id_usuario = uc.id_usuario
      LEFT JOIN
          cursos c ON uc.id_curso = c.id_curso
      LEFT JOIN
          usuario_materias um ON u.id_usuario = um.id_usuario
      LEFT JOIN
          materias m ON um.id_materia = m.id_materia
      LEFT JOIN
          usuario_seccion us ON u.id_usuario = us.id_usuario
      LEFT JOIN
          seccion s ON us.id_seccion = s.id_seccion
      LEFT JOIN
          direccion d ON u.id_direccion = d.id_direccion
      WHERE
          u.rol = 'profesor' AND u.estado = 0
      GROUP BY
          u.id_usuario
      ORDER BY
          u.primer_apellido ASC
      LIMIT ? OFFSET ?;
    `;

    // 🏆 Ejecutar la consulta y procesar los datos
    const [profesores] = await db.promise().query(profesoresQuery, [limit, offset]);


    res.json({
      profesores: profesores,
      totalCount,
      totalPages,
      currentPage: page
    });

  } catch (error) {
    console.error("❌ Error al obtener profesores:", error);
    res.status(500).json({ error: "Error al cargar profesores", detalle: error.message });
  }
});
router.put('/profesores/:id/estado', registrarAccion('Cambio de estado de profesor', 'usuarios'), async (req, res) => { // Eliminado el '/api'
    const { id } = req.params;
    const { estado } = req.body; 

    try {
      const updateEstadoQuery = `
        UPDATE usuarios
        SET estado = ?
        WHERE id_usuario = ?;
      `;
      await db.promise().query(updateEstadoQuery, [estado, id]);
      res.json({ message: `Estado del profesor ${id} actualizado a ${estado}.` });
    } catch (error) {
      console.error("❌ Error al actualizar estado del profesor:", error);
      res.status(500).json({ error: "Error al actualizar estado del profesor", detalle: error.message });
    }
});

// Endpoint para actualizar datos de un profesor (similar a estudiantes)
router.put('/profesores/:id', registrarAccion('Actualización de datos de profesor', 'usuarios'), async (req, res) => {
    const { id } = req.params;
    const {
      cedula, correo, primerNombre, segundoNombre, primerApellido, segundoApellido,
      telefono, direccion, materias, cursos, secciones, periodoAcademico 
    } = req.body;

    try {
      let id_direccion_a_usar = null;

      // 1. Obtener la dirección actual del usuario y sus detalles
      const [currentAddressResult] = await db.promise().query(`
          SELECT u.id_direccion, d.direccion, d.id_direccion, d.id_ciudad, d.id_estado
          FROM usuarios u
          LEFT JOIN direccion d ON u.id_direccion = d.id_direccion
          WHERE u.id_usuario = ?
      `, [id]);
      const currentAddress = currentAddressResult[0]; 

      if (currentAddress) {
          id_direccion_a_usar = currentAddress.id_direccion; 
      }

      // 2. Lógica para manejar la actualización de la dirección:
      const isAddressTextChanged = direccion !== undefined && direccion.trim() !== (currentAddress?.direccion || '').trim();

      if (isAddressTextChanged) {
          if (currentAddress && currentAddress.id_direccion) {
              await db.promise().query(
                  'UPDATE direccion SET direccion = ? WHERE id_direccion = ?',
                  [direccion.trim(), currentAddress.id_direccion]
              );
          } else {
              console.error(`❌ Error: El profesor ID ${id} no tiene una dirección asociada para actualizar, y la UI de edición no proporciona datos completos para insertar una nueva dirección.`);
              return res.status(400).json({ error: "No se pudo actualizar la dirección: El profesor no tiene una dirección asociada o faltan datos (ciudad/estado) para crear una nueva." });
          }
      }

      // Actualizar datos en la tabla 'usuarios'
      const updateUserQuery = `
        UPDATE usuarios
        SET
          cedula = ?,
          correo = ?,
          primer_nombre = ?,
          segundo_nombre = ?,
          primer_apellido = ?,
          segundo_apellido = ?,
          telefono = ?,
          id_direccion = ?
        WHERE id_usuario = ?;
      `;
      await db.promise().query(updateUserQuery, [
        cedula, correo, primerNombre, segundoNombre, primerApellido, segundoApellido,
        telefono, id_direccion_a_usar, id
      ]);

      if (periodoAcademico !== undefined && periodoAcademico !== '') { 
        const [existingPeriodo] = await db.promise().query('SELECT id_usuario_periodo FROM usuario_periodo WHERE id_usuario = ?', [id]);
        if (existingPeriodo.length > 0) {
          await db.promise().query('UPDATE usuario_periodo SET id_periodo = ? WHERE id_usuario = ?', [periodoAcademico, id]);
        } else {
          await db.promise().query('INSERT INTO usuario_periodo (id_usuario, id_periodo, fecha_inscripcion) VALUES (?, ?, CURDATE())', [id, periodoAcademico]);
        }
      }

      if (cursos !== undefined && cursos !== '' && cursos !== null && !(Array.isArray(cursos) && cursos.length === 0)) { 
        const [existingCurso] = await db.promise().query('SELECT id_usuario_cursos FROM usuario_cursos WHERE id_usuario = ?', [id]);
        const currentDateTime = new Date().toISOString().slice(0, 19).replace('T', ' ');
        if (existingCurso.length > 0) {
          await db.promise().query('UPDATE usuario_cursos SET id_curso = ?, fecha_inscripcion = ? WHERE id_usuario = ?', [cursos, currentDateTime, id]);
        } else {
          await db.promise().query('INSERT INTO usuario_cursos (id_usuario, id_curso, fecha_inscripcion) VALUES (?, ?, ?)', [id, cursos, currentDateTime]);
        }
      }

      if (materias !== undefined && materias !== '' && materias !== null && !(Array.isArray(materias) && materias.length === 0)) { 
        const [existingMateria] = await db.promise().query('SELECT id_usuario_materias FROM usuario_materias WHERE id_usuario = ?', [id]);
        if (existingMateria.length > 0) {
          await db.promise().query('UPDATE usuario_materias SET id_materia = ?, fecha_inscripcion = CURRENT_TIMESTAMP WHERE id_usuario = ?', [materias, id]);
        } else {
          await db.promise().query('INSERT INTO usuario_materias (id_usuario, id_materia, fecha_inscripcion) VALUES (?, ?, CURRENT_TIMESTAMP)', [id, materias]);
        }
      }

      if (secciones !== undefined && secciones !== '' && secciones !== null && !(Array.isArray(secciones) && secciones.length === 0)) { 
        const [existingSeccion] = await db.promise().query('SELECT id_usuario_seccion FROM usuario_seccion WHERE id_usuario = ?', [id]);
        if (existingSeccion.length > 0) {
          await db.promise().query('UPDATE usuario_seccion SET id_seccion = ? WHERE id_usuario = ?', [secciones, id]);
        } else {
          await db.promise().query('INSERT INTO usuario_seccion (id_usuario, id_seccion) VALUES (?, ?)', [id, secciones]);
        }
      }

      // Obtener los datos actualizados del profesor
      const [updatedProfesor] = await db.promise().query(`
        SELECT
          u.id_usuario,
          u.cedula,
          u.primer_nombre,
          u.segundo_nombre,
          u.primer_apellido,
          u.segundo_apellido,
          u.correo,
          u.telefono,
          d.direccion AS direccion,
          u.estado AS estado,
          u.ultima_conexion,
          IFNULL(GROUP_CONCAT(DISTINCT p.periodo ORDER BY p.periodo ASC), 'N/A') AS periodoAcademicoNames,
          IFNULL(GROUP_CONCAT(DISTINCT up.id_periodo ORDER BY up.id_periodo ASC), '') AS periodoAcademicoIds,
          IFNULL(GROUP_CONCAT(DISTINCT c.curso ORDER BY c.curso ASC), '') AS cursosNames,
          IFNULL(GROUP_CONCAT(DISTINCT uc.id_curso ORDER BY uc.id_curso ASC), '') AS cursosIds,
          IFNULL(GROUP_CONCAT(DISTINCT m.materia ORDER BY m.materia ASC), '') AS materiasNames,
          IFNULL(GROUP_CONCAT(DISTINCT um.id_materia ORDER BY um.id_materia ASC), '') AS materiasIds,
          IFNULL(GROUP_CONCAT(DISTINCT s.seccion ORDER BY s.seccion ASC), '') AS seccionNames,
          IFNULL(GROUP_CONCAT(DISTINCT us.id_seccion ORDER BY us.id_seccion ASC), '') AS seccionIds
        FROM
          usuarios u
        LEFT JOIN
          usuario_periodo up ON u.id_usuario = up.id_usuario
        LEFT JOIN
          periodo p ON up.id_periodo = p.id_periodo
        LEFT JOIN
          usuario_cursos uc ON u.id_usuario = uc.id_usuario
        LEFT JOIN
          cursos c ON uc.id_curso = c.id_curso
        LEFT JOIN
          usuario_materias um ON u.id_usuario = um.id_usuario
        LEFT JOIN
          materias m ON um.id_materia = m.id_materia
        LEFT JOIN
          usuario_seccion us ON u.id_usuario = us.id_usuario
        LEFT JOIN
          seccion s ON us.id_seccion = s.id_seccion
        LEFT JOIN
          direccion d ON u.id_direccion = d.id_direccion
        WHERE
          u.id_usuario = ?
        GROUP BY
          u.id_usuario;
      `, [id]);

      res.json({ 
        message: 'Profesor actualizado exitosamente',
        profesor: updatedProfesor[0]
      });

    } catch (error) {
      console.error("❌ Error al actualizar profesor:", error);
      res.status(500).json({ 
        error: "Error al actualizar profesor", 
        detalle: error.message 
      });
    }
});

router.get('/profesores/:id/academico', (req, res) => {
  const { id } = req.params;
  // Trae todas las relaciones cruzadas del profesor
  const sql = `
    SELECT
      p.periodo AS nombre_periodo,
      c.curso AS nombre_curso,
      m.materia AS nombre_materia,
      s.seccion AS nombre_seccion
    FROM usuario_materias um
    JOIN materias m ON um.id_materia = m.id_materia
    LEFT JOIN cursos c ON m.id_curso = c.id_curso
    LEFT JOIN materias_periodo mp ON m.id_materia = mp.id_materia
    LEFT JOIN periodo p ON mp.id_periodo = p.id_periodo
    LEFT JOIN materias_seccion ms ON m.id_materia = ms.id_materia
    LEFT JOIN seccion s ON ms.id_seccion = s.id_seccion
    WHERE um.id_usuario = ?;
  `;
  db.query(sql, [id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: 'Error al obtener información académica del profesor', detalle: err.message });
    }
    res.json({ academico: results });
  });
});



// Dashboard del profesor
// ... (imports y otras rutas existentes) ...

router.get('/profesor/mis-materias', /*isAuthenticated,*/ async (req, res) => {
    // Si tu middleware isAuthenticated adjunta el ID del usuario como req.user.id_usuario, úsalo directamente.
    // Si no tienes autenticación aún o para pruebas, puedes usar un ID fijo:
    const id_profesor = req.session.usuario ? req.session.usuario.id : null; 

    console.log("DEBUG: ID de profesor de la sesión:", id_profesor); // Para depuración

    if (!id_profesor) {
        // Si no hay ID de profesor en la sesión, el usuario no está autorizado
        return res.status(401).json({ error: 'No autorizado: ID de profesor no disponible en la sesión. Por favor, inicia sesión.' });
    }

    console.log(`DEBUG: Obteniendo materias para el profesor con ID: ${id_profesor}`);

    try {
        const query = `
            SELECT
                m.id_materia,
                m.materia AS nombre_materia,
                c.id_curso,
                c.curso AS nombre_curso,
                s.id_seccion,
                s.seccion AS nombre_seccion,
                p.id_periodo,
                p.periodo AS nombre_periodo,
                (
                    -- Contar estudiantes para esta combinación específica de materia-sección-período
                    SELECT COUNT(DISTINCT um_est.id_usuario)
                    FROM usuario_materias um_est
                    JOIN usuarios u_est ON um_est.id_usuario = u_est.id_usuario
                    -- Unir a materias_seccion y materias_periodo para filtrar por sección y período
                    JOIN materias_seccion ms_sub ON um_est.id_materia = ms_sub.id_materia
                    JOIN materias_periodo mp_sub ON um_est.id_materia = mp_sub.id_materia
                    WHERE um_est.id_materia = um.id_materia       -- Coincidir con la materia de la consulta externa
                      AND um_est.id_periodo = um.id_periodo       -- Coincidir con el período de la asignación del profesor
                      AND ms_sub.id_seccion = ms.id_seccion       -- Coincidir con la sección de la unión externa
                      AND mp_sub.id_periodo = um.id_periodo       -- Asegurar consistencia con el período
                      AND u_est.rol = 'estudiante'
                ) AS total_estudiantes
            FROM usuario_materias um -- Empezar por las asignaciones específicas del profesor
            JOIN usuarios u ON um.id_usuario = u.id_usuario
            JOIN materias m ON um.id_materia = m.id_materia
            LEFT JOIN cursos c ON m.id_curso = c.id_curso
            
            -- Unir para obtener la información de la sección de la materia
            JOIN materias_seccion ms ON m.id_materia = ms.id_materia
            JOIN seccion s ON ms.id_seccion = s.id_seccion
            
            -- Unir para obtener la información del período, ¡CRUCIALMENTE usando um.id_periodo para la coincidencia!
            JOIN materias_periodo mp ON um.id_materia = mp.id_materia AND um.id_periodo = mp.id_periodo
            JOIN periodo p ON um.id_periodo = p.id_periodo 
            
            WHERE u.rol = 'profesor' AND u.id_usuario = ?
            GROUP BY m.id_materia, c.id_curso, s.id_seccion, p.id_periodo
            ORDER BY p.periodo DESC, s.seccion, m.materia;
        `;
        db.query(query, [id_profesor], (err, results) => {
            if (err) {
                console.error("❌ Error al obtener materias del profesor:", err);
                return res.status(500).json({ error: "Error al obtener materias del profesor", detalle: err.message });
            }
            res.json(results);
        });

    } catch (error) {
        console.error("❌ Error en la ruta /profesor/mis-materias:", error);
        res.status(500).json({ error: "Error interno del servidor", detalle: error.message });
    }
});


router.get('/profesor/sidebard', /*isAuthenticated,*/ async (req, res) => {
    // Si tu middleware isAuthenticated adjunta el ID del usuario como req.user.id_usuario, úsalo directamente.
    // Si no tienes autenticación aún o para pruebas, puedes usar un ID fijo:
    const id_profesor = req.session.usuario ? req.session.usuario.id : null; 

    console.log("DEBUG: Professor ID from session:", id_profesor); // For debugging

    if (!id_profesor) {
        // Si no hay ID de profesor en la sesión, el usuario no está autorizado
        return res.status(401).json({ error: 'Unauthorized: Professor ID not available in session. Please log in.' });
    }

    console.log(`DEBUG: Getting subjects for professor with ID: ${id_profesor}`);

    try {
        const query = `
            SELECT
                m.id_materia,
                m.materia AS nombre_materia,
                c.id_curso,
                c.curso AS nombre_curso,
                s.id_seccion,
                s.seccion AS nombre_seccion,
                p.id_periodo,
                p.periodo AS nombre_periodo
            FROM usuario_materias um -- Empezar por las asignaciones específicas del profesor
            JOIN usuarios u ON um.id_usuario = u.id_usuario
            JOIN materias m ON um.id_materia = m.id_materia
            LEFT JOIN cursos c ON m.id_curso = c.id_curso
            
            -- Unir para obtener la información de la sección de la materia
            JOIN materias_seccion ms ON m.id_materia = ms.id_materia
            JOIN seccion s ON ms.id_seccion = s.id_seccion
            
            -- Unir para obtener la información del período, ¡CRUCIALMENTE usando um.id_periodo para la coincidencia!
            JOIN materias_periodo mp ON um.id_materia = mp.id_materia AND um.id_periodo = mp.id_periodo
            JOIN periodo p ON um.id_periodo = p.id_periodo 
            
            WHERE u.rol = 'profesor' AND u.id_usuario = ?
            GROUP BY m.id_materia, c.id_curso, s.id_seccion, p.id_periodo
            ORDER BY p.periodo DESC, s.seccion, m.materia;
        `;
        // Using db.promise().query for consistency with other routes in this file
        const [results] = await db.promise().query(query, [id_profesor]);
        res.json(results);

    } catch (error) {
        console.error("❌ Error getting professor's subjects for sidebar:", error);
        res.status(500).json({ error: "Error getting professor's subjects for sidebar", detalle: error.message });
    }
});



export default router;
