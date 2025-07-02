import express from 'express';
import db from '../db/db.js'; // Ajusta esta ruta si es necesario
import { isAuthenticated } from '../middleware/protegerRutas.js'; // Ajusta esta ruta si es necesario
import { hashPassword, comparePassword } from '../f(x)/contrasenias.js'; // Ajusta esta ruta si es necesario
import { syncRelationships, syncSingleRelationship } from '../f(x)/relaciones.js'; // Ajusta esta ruta si es necesario
import { registrarAccion } from '../middleware/historial.js';

const router = express.Router();

router.get('/estudiantes', async (req, res) => {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 5;
    // NUEVO: Captura el término de búsqueda de la URL
    const searchTerm = req.query.search ? req.query.search.toLowerCase() : '';
    const offset = (page - 1) * limit;

    try {
        let baseWhereClause = `WHERE u.rol = 'estudiante'`;
        let countWhereClause = `WHERE rol = 'estudiante'`; // Para las consultas COUNT que no usan JOIN
        let queryParams = []; // Parámetros para las consultas SQL

        // Si hay un término de búsqueda, añadirlo a la cláusula WHERE
        if (searchTerm) {
            // Se busca en primer_nombre O primer_apellido (o ambos)
            baseWhereClause += ` AND (LOWER(u.primer_nombre) LIKE ? OR LOWER(u.primer_apellido) LIKE ?)`;
            countWhereClause += ` AND (LOWER(primer_nombre) LIKE ? OR LOWER(primer_apellido) LIKE ?)`;
            queryParams.push(`%${searchTerm}%`, `%${searchTerm}%`);
        }

        // 1️⃣ Consulta para el total de estudiantes (con o sin filtro de búsqueda)
        const [totalStudentsResult] = await db.promise().query(
            `SELECT COUNT(*) AS total FROM usuarios ${countWhereClause};`,
            queryParams
        );
        const totalCount = totalStudentsResult[0].total;

        // 2️⃣ Consulta para el total de estudiantes activos (con o sin filtro de búsqueda)
        const [activeStudentsResult] = await db.promise().query(
            `SELECT COUNT(*) AS active FROM usuarios ${countWhereClause} AND estado = 1;`,
            queryParams
        );
        const activeCount = activeStudentsResult[0].active;

        // 3️⃣ Consulta para el total de estudiantes inactivos (con o sin filtro de búsqueda)
        const [inactiveStudentsResult] = await db.promise().query(
            `SELECT COUNT(*) AS inactive FROM usuarios ${countWhereClause} AND estado = 0;`,
            queryParams
        );
        const inactiveCount = inactiveStudentsResult[0].inactive;

        const totalPages = Math.ceil(totalCount / limit);

        // 4️⃣ Consulta optimizada para obtener los estudiantes con todos los detalles
        const studentsQuery = `
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
        const [estudiantes] = await db.promise().query(
            studentsQuery,
            [...queryParams, parseInt(limit), offset] // Añadir los parámetros de paginación al final
        );

        res.json({
            estudiantes: estudiantes,
            totalCount,
            activeCount,
            inactiveCount,
            totalPages,
            currentPage: page
        });

    } catch (error) {
        console.error("❌ Error al obtener estudiantes:", error);
        res.status(500).json({ error: "Error al cargar estudiantes", detalle: error.message });
    }
});

router.get('/estudiantes/papelera', async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 5;
  const offset = (page - 1) * limit;

  try {
    // 1️⃣ Consulta para el total de estudiantes
    const [totalStudentsResult] = await db.promise().query('SELECT COUNT(*) AS total FROM usuarios WHERE rol = "estudiante" AND estado = 0;');
    const totalCount = totalStudentsResult[0].total;

    // 2️⃣ Consulta para el total de estudiantes activos
    const [activeStudentsResult] = await db.promise().query('SELECT COUNT(*) AS active FROM usuarios WHERE rol = "estudiante" AND estado = 1;');
    const activeCount = activeStudentsResult[0].active;

    // 3️⃣ Consulta para el total de estudiantes inactivos
    const [inactiveStudentsResult] = await db.promise().query('SELECT COUNT(*) AS inactive FROM usuarios WHERE rol = "estudiante" AND estado = 0;');
    const inactiveCount = inactiveStudentsResult[0].inactive;

    const totalPages = Math.ceil(totalCount / limit);

    // 4️⃣ Consulta optimizada para obtener los estudiantes con todos los detalles
    const studentsQuery = `
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
          u.rol = 'estudiante' AND u.estado = '0'
      GROUP BY
          u.id_usuario
      ORDER BY
          u.primer_apellido ASC
      LIMIT ? OFFSET ?;
    `;

    // 🏆 Ejecutar la consulta y procesar los datos
    const [estudiantes] = await db.promise().query(studentsQuery, [limit, offset]);


    res.json({
      estudiantes: estudiantes,
      totalCount,
      activeCount,
      inactiveCount,
      totalPages,
      currentPage: page
    });

  } catch (error) {
    console.error("❌ Error al obtener estudiantes:", error);
    res.status(500).json({ error: "Error al cargar estudiantes", detalle: error.message });
  }
});

router.put('/estudiantes/:id/estado', registrarAccion('Actualizacion estado estudiante', 'usuarios'), async (req, res) => { // Eliminado el '/api'
    const { id } = req.params;
    const { estado } = req.body; 

    try {
      const updateEstadoQuery = `
        UPDATE usuarios
        SET estado = ?
        WHERE id_usuario = ?;
      `;
      await db.promise().query(updateEstadoQuery, [estado, id]);
      res.json({ message: `Estado del estudiante ${id} actualizado a ${estado}.` });
    } catch (error) {
      console.error("❌ Error al actualizar estado del estudiante:", error);
      res.status(500).json({ error: "Error al actualizar estado del estudiante", detalle: error.message });
    }
});

router.put('/estudiantes/:id', registrarAccion('Actualizacion datos estudiante', 'usuarios'), async (req, res) => { // Eliminado el '/api'
    const { id } = req.params;
    const {
      cedula, correo, primerNombre, segundoNombre, primerApellido, segundoApellido,
      telefono, direccion, materias, cursos, secciones, periodoAcademico 
    } = req.body;

    try {
      let id_direccion_a_usar = null;

      // 1. Obtener la dirección actual del usuario y sus detalles (id_direccion, direccion_texto, id_ciudad, id_estado)
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
      // Comprobar si el texto de la dirección proporcionado en el cuerpo de la solicitud es diferente al actual del estudiante
      const isAddressTextChanged = direccion !== undefined && direccion.trim() !== (currentAddress?.direccion || '').trim();

      if (isAddressTextChanged) {
          // Si el estudiante ya tiene una dirección asociada (lo cual debería ser el caso para una actualización)
          if (currentAddress && currentAddress.id_direccion) {
              // ACTUALIZAR el texto de la dirección en el registro existente de la tabla 'direccion'
              // NO se modifican id_ciudad o id_estado, solo el texto de la dirección.
              await db.promise().query(
                  'UPDATE direccion SET direccion = ? WHERE id_direccion = ?',
                  [direccion.trim(), currentAddress.id_direccion]
              );
          } else {
              console.error(`❌ Error: El estudiante ID ${id} no tiene una dirección asociada para actualizar, y la UI de edición no proporciona datos completos para insertar una nueva dirección.`);
              return res.status(400).json({ error: "No se pudo actualizar la dirección: El estudiante no tiene una dirección asociada o faltan datos (ciudad/estado) para crear una nueva." });
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
      const [userUpdateResult] = await db.promise().query(updateUserQuery, [
        cedula, correo, primerNombre, segundoNombre, primerApellido, segundoApellido,
        telefono, id_direccion_a_usar, id
      ]);

      if (periodoAcademico !== undefined && periodoAcademico !== '') { 
        // Verificar si existe un registro para este usuario
        const [existingPeriodo] = await db.promise().query('SELECT id_usuario_periodo FROM usuario_periodo WHERE id_usuario = ?', [id]);
        
        if (existingPeriodo.length > 0) {
          // Si existe, actualizar solo el periodo
          await db.promise().query('UPDATE usuario_periodo SET id_periodo = ? WHERE id_usuario = ?', [periodoAcademico, id]);
        } else {
          // Si no existe, crear uno nuevo
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

      // Obtener los datos actualizados del estudiante
      const [updatedStudent] = await db.promise().query(`
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
        message: 'Estudiante actualizado exitosamente',
        estudiante: updatedStudent[0]
      });

    } catch (error) {
      console.error("❌ Error al actualizar estudiante:", error);
      res.status(500).json({ 
        error: "Error al actualizar estudiante", 
        detalle: error.message 
      });
    }
}); 

router.get('/estudiantes/:id/academico', (req, res) => {
    const { id } = req.params;

    if (!id) {
        return res.status(400).json({ error: 'ID de usuario no proporcionado.' });
    }

    const sql = `
        SELECT
            p.periodo AS nombre_periodo,
            c.curso AS nombre_curso,
            m.materia AS nombre_materia,
            s.seccion AS nombre_seccion,
            CONCAT(p.periodo, ' - ', m.materia) AS periodo_materia_display, -- Nuevo campo combinado
            COALESCE(
                SUM(CASE WHEN n.nota IS NOT NULL THEN (n.nota * a.ponderacion) / 100 ELSE 0 END),
                0.00
            ) AS nota_final_materia,
            CASE
                WHEN COALESCE(
                        SUM(CASE WHEN n.nota IS NOT NULL THEN (n.nota * a.ponderacion) / 100 ELSE 0 END),
                        0.00
                     ) >= 10 THEN 'Aprobado'
                ELSE 'Reprobado'
            END AS estado_materia
        FROM usuario_materias um
        JOIN materias m ON um.id_materia = m.id_materia
        LEFT JOIN cursos c ON m.id_curso = c.id_curso
        LEFT JOIN periodo p ON um.id_periodo = p.id_periodo
        LEFT JOIN cursos_seccion cs ON c.id_curso = cs.id_curso
        LEFT JOIN seccion s ON cs.id_seccion = s.id_seccion
        LEFT JOIN actividades a ON m.id_materia = a.id_materia
        LEFT JOIN notas n ON a.id_actividad = n.id_actividad AND um.id_usuario = n.id_estudiante
        WHERE um.id_usuario = ?
        GROUP BY
            um.id_usuario_materias,
            p.periodo,
            c.curso,
            m.materia,
            s.seccion,
            m.id_materia
        ORDER BY p.periodo DESC, m.materia ASC;
    `;

    db.query(sql, [id], (err, results) => {
        if (err) {
            console.error('Error al obtener información académica del estudiante:', err);
            return res.status(500).json({ error: 'Error al obtener información académica.', detalle: err.message });
        }
        res.json({ academico: results });
    });
});



router.get('/estudiantes/mis-materias', /*isAuthenticated,*/ async (req, res) => {
    // If your isAuthenticated middleware attaches the user ID as req.user.id_usuario, use it directly.
    // If you don't have authentication yet or for testing, you can use a fixed ID:
    const id_estudiante = req.session.usuario ? req.session.usuario.id : null; 

    console.log("DEBUG: Student ID from session:", id_estudiante); // For debugging

    if (!id_estudiante) {
        // If there's no student ID in the session, the user is not authorized
        return res.status(401).json({ error: 'Unauthorized: Student ID not available in session. Please log in.' });
    }

    console.log(`DEBUG: Getting subjects for student with ID: ${id_estudiante}`);

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
                -- Subquery to count students in this specific subject-section-period combination
                -- This subquery now correctly references ms.id_seccion and um_est.id_periodo
                (
                    SELECT COUNT(DISTINCT um_est.id_usuario)
                    FROM usuario_materias um_est
                    JOIN usuarios u_est ON um_est.id_usuario = u_est.id_usuario
                    -- Join to materias_seccion and materias_periodo to filter by section and period
                    JOIN materias_seccion ms_est ON um_est.id_materia = ms_est.id_materia
                    JOIN materias_periodo mp_est ON um_est.id_materia = mp_est.id_materia
                    WHERE um_est.id_materia = um.id_materia
                      AND ms_est.id_seccion = ms.id_seccion -- Use ms.id_seccion from outer query's join
                      AND um_est.id_periodo = um.id_periodo -- Use um.id_periodo from outer query's main table
                      AND u_est.rol = 'estudiante'
                ) AS total_estudiantes,
                -- Subquery to get the professor assigned to this specific combination
                -- This subquery now correctly references ms.id_seccion and um_prof_sub.id_periodo
                (
                    SELECT CONCAT(prof_sub.primer_nombre, ' ', prof_sub.primer_apellido)
                    FROM usuario_materias um_prof_sub
                    JOIN usuarios prof_sub ON um_prof_sub.id_usuario = prof_sub.id_usuario
                    -- Join to materias_seccion and materias_periodo to filter by section and period
                    JOIN materias_seccion ms_prof_sub ON um_prof_sub.id_materia = ms_prof_sub.id_materia
                    JOIN materias_periodo mp_prof_sub ON um_prof_sub.id_materia = mp_prof_sub.id_materia
                    WHERE um_prof_sub.id_materia = um.id_materia
                      AND ms_prof_sub.id_seccion = ms.id_seccion -- Use ms.id_seccion from outer query's join
                      AND um_prof_sub.id_periodo = um.id_periodo -- Use um.id_periodo from outer query's main table
                      AND prof_sub.rol = 'profesor'
                    LIMIT 1
                ) AS nombre_completo_profesor
            FROM usuario_materias um -- Start from the direct association table which has id_periodo
            JOIN usuarios u ON um.id_usuario = u.id_usuario
            JOIN materias m ON um.id_materia = m.id_materia
            LEFT JOIN cursos c ON m.id_curso = c.id_curso
            -- Join to materias_seccion and then seccion to get section details
            JOIN materias_seccion ms ON m.id_materia = ms.id_materia
            JOIN seccion s ON ms.id_seccion = s.id_seccion
            -- Join directly to periodo from usuario_materias since it has id_periodo
            JOIN periodo p ON um.id_periodo = p.id_periodo 
            WHERE u.rol = 'estudiante' 
              AND u.id_usuario = ?
            GROUP BY m.id_materia, c.id_curso, s.id_seccion, p.id_periodo 
            ORDER BY p.periodo DESC, s.seccion, m.materia;
        `;
        db.query(query, [id_estudiante], (err, results) => {
            if (err) {
                console.error("❌ Error getting student's subjects:", err);
                return res.status(500).json({ error: "Error getting student's subjects", detail: err.message });
            }
            res.json(results);
        });

    } catch (error) {
        console.error("❌ Error in /estudiantes/mis-materias route:", error);
        res.status(500).json({ error: "Internal server error", detail: error.message });
    }
});






/**
 * @route GET /api/notas/materia/:id_materia/usuario/:id_usuario
 * @description Obtiene todas las notas de un estudiante específico para una materia, incluyendo detalles de la actividad y comentarios asociados.
 * @param {number} req.params.id_materia - ID de la materia.
 * @param {number} req.params.id_usuario - ID del estudiante.
 * @param {number} [req.query.page=1] - Número de página para la paginación.
 * @param {number} [req.query.limit=10] - Límite de resultados por página.
 * @returns {json} Lista de notas paginadas con detalles de actividad y comentarios.
 */
router.get('/notas/materia/:id_materia/estudiante/:id_usuario', async (req, res) => {
    const { id_materia, id_usuario } = req.params;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const { id_periodo } = req.query; // ¡Ahora obtenemos el id_periodo de los query parameters!

    // Validar que id_periodo esté presente
    if (!id_periodo) {
        return res.status(400).json({ error: 'Debes especificar el ID del periodo para obtener las notas.' });
    }

    try {
        // Consulta para el conteo total de notas del estudiante para esa materia y período
        const countSql = `
            SELECT COUNT(n.id_nota) AS total
            FROM notas n
            JOIN actividades a ON n.id_actividad = a.id_actividad
            WHERE n.id_estudiante = ? 
              AND a.id_materia = ? 
              AND a.id_periodo = ?
        `;
        const [[{ total }]] = await db.promise().query(countSql, [id_usuario, id_materia, id_periodo]);
        const totalCount = total;
        const totalPages = Math.ceil(totalCount / limit);

        // Consulta para obtener las notas del estudiante para la materia y período con detalles de actividad y comentarios
        const sql = `
            SELECT
                n.id_nota,
                n.nota,
                -- Usar COALESCE para asegurar que fecha_registro no sea NULL, o usar la fecha de comentario si es más relevante
                COALESCE(n.fecha_registro, c.fecha_hora) AS fecha_registro, 
                n.id_estudiante,
                a.id_actividad,
                a.nombre_actividad,
                a.descripcion AS descripcion_actividad,
                a.ponderacion,
                c.mensaje AS comentarios, -- Se mantiene como 'comentarios' para el frontend
                c.fecha_hora AS fecha_comentario_original -- Columna para depuración si es necesario
            FROM notas n
            JOIN actividades a ON n.id_actividad = a.id_actividad
            LEFT JOIN comentarios c ON n.id_estudiante = c.id_estudiante AND n.id_actividad = c.id_actividad
            WHERE n.id_estudiante = ? 
              AND a.id_materia = ? 
              AND a.id_periodo = ? 
            ORDER BY n.fecha_registro DESC
            LIMIT ? OFFSET ?
        `;
        const [notas] = await db.promise().query(sql, [id_usuario, id_materia, id_periodo, limit, offset]);

        // Debugging: Log the notes data right before sending it to the frontend
        console.log('DEBUG (API): Datos de notas enviados al frontend:', notas);

        res.json({ notas, totalCount, totalPages, currentPage: page });

    } catch (err) {
        console.error('Error al obtener notas de la materia por usuario:', err);
        res.status(500).json({ error: 'Error al obtener notas', detalle: err.message });
    }
});




router.get('/notas/estudiante/:id_materia', async (req, res) => {
  const { id_materia } = req.params;
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const offset = (page - 1) * limit;

  try {
      const countSql = `
        SELECT COUNT(*) AS total
        FROM notas n
        JOIN actividades a ON n.id_actividad = a.id_actividad
        WHERE a.id_materia = ?
      `;
      const [[{ total }]] = await db.promise().query(countSql, [id_materia]);
      const totalCount = total;
      const totalPages = Math.ceil(totalCount / limit);

      const sql = `
        SELECT
          n.id_nota,
          n.nota,
          n.fecha_registro,
          n.comentarios, -- Asegura que los comentarios se recuperen aquí también
          n.id_estudiante,
          a.id_actividad,
          u.primer_nombre AS nombre_estudiante,
          u.primer_apellido AS apellido_estudiante,
          m.materia AS nombre_materia,
          a.nombre_actividad,
          a.descripcion AS descripcion_actividad,
          a.ponderacion -- Se añadió ponderacion aquí para obtener el promedio ponderado
        FROM notas n
        JOIN usuarios u ON n.id_estudiante = u.id_usuario
        JOIN actividades a ON n.id_actividad = a.id_actividad
        JOIN materias m ON a.id_materia = m.id_materia
        WHERE m.id_materia = ?
        ORDER BY u.primer_nombre, a.nombre_actividad, n.fecha_registro DESC
        LIMIT ? OFFSET ?
      `;
      const [notas] = await db.promise().query(sql, [id_materia, limit, offset]);
      
      res.json({ notas, totalCount, totalPages, currentPage: page });

  } catch (err) {
      res.status(500).json({ error: 'Error al obtener calificaciones', detalle: err.message });
  }
});

router.get('/estudiantes/sidebard', /*isAuthenticated,*/ async (req, res) => {
    const id_estudiante = req.session.usuario ? req.session.usuario.id : null; 

    console.log("DEBUG: Student ID from session (sidebar):", id_estudiante); 

    if (!id_estudiante) {
        return res.status(401).json({ error: 'Unauthorized: Student ID not available in session. Please log in.' });
    }

    console.log(`DEBUG: Getting subjects for student sidebar with ID: ${id_estudiante}`);

    try {
        const query = `
            SELECT
                m.id_materia,
                m.materia AS nombre_materia,
                p.id_periodo,
                p.periodo AS nombre_periodo,
                s.id_seccion,
                s.seccion AS nombre_seccion,
                c.id_curso,
                c.curso AS nombre_curso
            FROM usuario_materias um
            JOIN usuarios u ON um.id_usuario = u.id_usuario
            JOIN materias m ON um.id_materia = m.id_materia
            JOIN periodo p ON um.id_periodo = p.id_periodo
            JOIN materias_seccion ms ON m.id_materia = ms.id_materia
            JOIN seccion s ON ms.id_seccion = s.id_seccion
            LEFT JOIN cursos c ON m.id_curso = c.id_curso
            WHERE u.rol = 'estudiante' AND u.id_usuario = ?
            GROUP BY m.id_materia, p.id_periodo, s.id_seccion, c.id_curso
            ORDER BY p.periodo DESC, m.materia;
        `;
        const [results] = await db.promise().query(query, [id_estudiante]);
        res.json(results);

    } catch (error) {
        console.error("❌ Error getting student's subjects for sidebar:", error);
        res.status(500).json({ error: "Error getting student's subjects for sidebar", detalle: error.message });
    }
});




export default router;