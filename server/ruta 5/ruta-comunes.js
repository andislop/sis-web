// routes/ruta-comunes.js
import express from 'express';
import db from '../db/db.js'; // Ajusta esta ruta si es necesario
import { isAuthenticated } from '../middleware/protegerRutas.js'; // Ajusta esta ruta si es necesario

const router = express.Router();

// --- Rutas de Comunes (API endpoints) ---

// Obtener historial de acciones (solo admin)
router.get('/historial', isAuthenticated, (req, res) => {
    if (req.session.usuario.rol !== 'admin') {
        return res.status(403).json({ error: 'Acceso no autorizado' });
    }
    
    const { pagina = 1, porPagina = 20, id_usuario, fecha_inicio, fecha_fin, accion } = req.query;
    const offset = (pagina - 1) * porPagina;
    
    let sql = `
        SELECT h.*, u.primer_nombre, u.primer_apellido, u.rol 
        FROM historial_acciones h
        JOIN usuarios u ON h.id_usuario = u.id_usuario
        WHERE 1=1
    `;
    const params = [];
    
    if (id_usuario) {
        sql += ' AND h.id_usuario = ?';
        params.push(id_usuario);
    }
    
    if (fecha_inicio) {
        sql += ' AND h.fecha_hora >= ?';
        params.push(fecha_inicio);
    }
    
    if (fecha_fin) {
        sql += ' AND h.fecha_hora <= ?';
        params.push(fecha_fin + ' 23:59:59');
    }
    
    if (accion) {
        sql += ' AND h.accion LIKE ?';
        params.push(`%${accion}%`);
    }
    
    sql += ' ORDER BY h.fecha_hora DESC LIMIT ? OFFSET ?';
    params.push(parseInt(porPagina), parseInt(offset));
    
    db.query(sql, params, (err, results) => {
        if (err) {
            console.error('Error al obtener historial:', err);
            return res.status(500).json({ error: 'Error al obtener historial' });
        }
        
        // Obtener el total de registros para paginación
        db.query(
            'SELECT COUNT(*) AS total FROM historial_acciones',
            (err, countResults) => {
                if (err) {
                    console.error('Error al contar historial:', err);
                    return res.status(500).json({ error: 'Error al contar registros' });
                }
                
                const total = countResults[0].total;
                const totalPaginas = Math.ceil(total / porPagina);
                
                res.json({
                    datos: results,
                    paginacion: {
                        pagina: parseInt(pagina),
                        porPagina: parseInt(porPagina),
                        total,
                        totalPaginas
                    }
                });
            }
        );
    });
});

// Obtener estadísticas de acciones (solo admin)
router.get('/historial/estadisticas', isAuthenticated, (req, res) => {
    if (req.session.usuario.rol !== 'admin') {
        return res.status(403).json({ error: 'Acceso no autorizado' });
    }
    
    const { periodo = 'dia' } = req.query; // Puede ser 'dia', 'semana', 'mes'
    
    let sql = '';
    if (periodo === 'dia') {
        sql = `
            SELECT 
                DATE(fecha_hora) AS fecha,
                COUNT(*) AS total_acciones,
                SUM(accion LIKE '%login%') AS logins,
                SUM(accion LIKE '%elimin%') AS eliminaciones,
                SUM(accion LIKE '%actualiz%') AS actualizaciones
            FROM historial_acciones
            WHERE fecha_hora >= DATE_SUB(NOW(), INTERVAL 30 DAY)
            GROUP BY DATE(fecha_hora)
            ORDER BY fecha DESC
        `;
    } else if (periodo === 'semana') {
        sql = `
            SELECT 
                YEAR(fecha_hora) AS año,
                WEEK(fecha_hora) AS semana,
                COUNT(*) AS total_acciones
            FROM historial_acciones
            WHERE fecha_hora >= DATE_SUB(NOW(), INTERVAL 12 WEEK)
            GROUP BY YEAR(fecha_hora), WEEK(fecha_hora)
            ORDER BY año DESC, semana DESC
        `;
    } else { // mes
        sql = `
            SELECT 
                YEAR(fecha_hora) AS año,
                MONTH(fecha_hora) AS mes,
                COUNT(*) AS total_acciones
            FROM historial_acciones
            WHERE fecha_hora >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
            GROUP BY YEAR(fecha_hora), MONTH(fecha_hora)
            ORDER BY año DESC, mes DESC
        `;
    }
    
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error al obtener estadísticas:', err);
            return res.status(500).json({ error: 'Error al obtener estadísticas' });
        }
        
        res.json(results);
    });
});

// Obtener notificaciones pendientes
router.get('/notificaciones', isAuthenticated, (req, res) => {
  // Check if user role is 'admin'
  if (!req.session.usuario || req.session.usuario.rol !== 'admin') {
    return res.status(403).json({ error: 'Access denied: Only administrators can view notifications.' });
  }

  db.query(`
    SELECT 
      n.id_notificacion,
      n.id_usuario,
      u.primer_nombre,
      u.primer_apellido,
      u.cedula,
      n.mensaje,
      n.fecha,
      n.estado
    FROM notificaciones n
    JOIN usuarios u ON n.id_usuario = u.id_usuario
    WHERE n.estado = 'pendiente'
    ORDER BY n.fecha DESC;
  `, (err, results) => {
    if (err) {
      console.error("Error obteniendo notificaciones:", err);
      return res.status(500).json({ error: "Error al obtener notificaciones" });
    }
    res.json({ notificaciones: results });
  });
});

// Asegúrate de importar tu conexión a la base de datos y la autenticación si es necesaria
// const db = require('../config/db'); // O tu archivo de conexión
// const router = require('express').Router();
// const isAuthenticated = require('../middlewares/isAuthenticated'); // Si tienes un middleware de autenticación

// API Principal: Ruta para obtener comentarios de un estudiante (modificada para usar la autenticación y el campo 'leido_por_estudiante')
router.get('/comentarios', isAuthenticated, async (req, res) => {
    // 1. Verificación de rol: Solo estudiantes pueden acceder a sus comentarios.
    if (!req.session.usuario || req.session.usuario.rol !== 'estudiante') {
        console.warn(`Intento de acceso no autorizado a /comentarios por usuario con rol: ${req.session.usuario?.rol || 'N/A'}`);
        return res.status(403).json({ error: 'Acceso denegado: Solo los estudiantes pueden ver sus comentarios.' });
    }

    // 2. Obtener el ID del estudiante desde la sesión del usuario autenticado.
    const id_estudiante_actual = req.session.usuario.id; 

    if (!id_estudiante_actual) {
        console.error("Error: ID de estudiante no encontrado en la sesión para /comentarios.");
        return res.status(400).json({ error: 'ID de estudiante no disponible en la sesión.' });
    }

    console.log(`DEBUG: Obteniendo comentarios para el estudiante con ID: ${id_estudiante_actual}`);

    try {
        // 3. Consulta SQL para obtener los comentarios dirigidos a este estudiante,
        // incluyendo el estado de 'leido_por_estudiante' y la información del remitente.
        const query = `
            SELECT 
                c.id_comentario,
                c.id_estudiante,
                c.id_actividad,
                a.nombre_actividad,
                c.mensaje AS contenido,               -- Contenido del comentario (el frontend espera 'contenido')
                c.leido_por_estudiante,             -- ¡IMPORTANTE: Columna para el estado de lectura!
                c.fecha_hora AS fecha_creacion,     -- Fecha de creación del comentario (el frontend espera 'fecha_creacion')
                u_emisor.primer_nombre AS nombre_profesor,   -- Nombre del remitente (profesor/admin, el frontend espera 'nombre_profesor')
                u_emisor.primer_apellido AS apellido_profesor, -- Apellido del remitente (el frontend espera 'apellido_profesor')
                u_emisor.rol AS rol_emisor,
                u_emisor.cedula AS cedula_emisor
            FROM comentarios c
            JOIN actividades a ON c.id_actividad = a.id_actividad
            JOIN usuarios u_emisor ON c.id_usuario = u_emisor.id_usuario -- Unir con usuarios para obtener datos del remitente
            WHERE c.id_estudiante = ?
            ORDER BY c.fecha_hora DESC;
        `;
        
        const [results] = await db.promise().query(query, [id_estudiante_actual]);

        // 4. Enviar los comentarios como respuesta JSON.
        res.json({ comentarios: results });

    } catch (err) {
        console.error("❌ Error obteniendo comentarios para el estudiante:", err);
        res.status(500).json({ error: "Error al obtener comentarios", detalle: err.message });
    }
});

// NUEVA API: Marcar uno o varios comentarios como leídos
router.put('/comentarios/marcar-leido', /*isAuthenticated,*/ async (req, res) => {
    // Para mayor seguridad, verifica que el usuario en sesión sea el estudiante al que pertenecen los comentarios
    const estudianteId = req.session.usuario ? req.session.usuario.id : null;
    if (!estudianteId) {
        return res.status(401).json({ error: 'Unauthorized: Student ID not available in session.' });
    }

    const { comentarioIds } = req.body; // Esperamos un array de IDs de comentarios

    if (!comentarioIds || !Array.isArray(comentarioIds) || comentarioIds.length === 0) {
        return res.status(400).json({ error: 'Se requiere un array de IDs de comentarios para marcar como leídos.' });
    }

    try {
        // Asegúrate de que solo los comentarios de este estudiante sean marcados
        const query = `
            UPDATE comentarios
            SET leido_por_estudiante = TRUE 
            WHERE id_comentario IN (?) AND id_estudiante = ?;
        `;
        const [result] = await db.promise().query(query, [comentarioIds, estudianteId]);
        
        // Opcional: Si tienes una tabla de notificaciones, actualiza o elimina la notificación relevante.
        // Por ejemplo, si tienes una notificación general "hay comentarios nuevos".
        // UPDATE notificaciones SET leido = TRUE WHERE tipo = 'comentario_nuevo' AND id_usuario = ?;

        res.json({ message: `${result.affectedRows} comentarios marcados como leídos.` });
    } catch (error) {
        console.error("Error al marcar comentarios como leídos:", error);
        res.status(500).json({ error: "Error interno del servidor al marcar comentarios como leídos", detalle: error.message });
    }
});

// NUEVA API: Obtener el conteo de comentarios no leídos para el estudiante logueado
router.get('/estudiantes/comentarios/no-leidos/count', /*isAuthenticated,*/ async (req, res) => {
    const estudianteId = req.session.usuario ? req.session.usuario.id : null;

    if (!estudianteId) {
        return res.status(401).json({ error: 'Unauthorized: Student ID not available in session.' });
    }

    try {
        const query = `
            SELECT COUNT(*) AS count
            FROM comentarios
            WHERE id_estudiante = ? AND leido_por_estudiante = FALSE; 
        `;
        const [results] = await db.promise().query(query, [estudianteId]);
        const unreadCount = results[0] ? results[0].count : 0;
        res.json({ count: unreadCount });
    } catch (error) {
        console.error("Error al obtener el conteo de comentarios no leídos:", error);
        res.status(500).json({ error: "Error interno del servidor al obtener el conteo de comentarios no leídos", detalle: error.message });
    }
});

// Exporta el router si estás usando módulos
// module.exports = router;




// Obtener estados
router.get('/estados', (req, res) => { // No requiere autenticación si es para todos
  db.query('SELECT id_estado, estados FROM estados ORDER BY estados', (err, results) => {
    if (err) {
      console.error('Error en la consulta de estados:', err);
      return res.status(500).json({ error: 'Error al obtener estados' });
    }
    res.json(results);
  });
});

// Obtener ciudades por estado
router.get('/estados/:id/ciudades', (req, res) => { // No requiere autenticación si es para todos
  const estadoId = req.params.id;
  db.query(
    'SELECT id_ciudad, ciudad FROM ciudades WHERE id_estado = ? ORDER BY ciudad',
    [estadoId],
    (err, results) => {
      if (err) return res.status(500).json({ error: 'Error al obtener ciudades' });
      res.json(results);
    }
  );
});

// Verificar si cédula existe
router.get('/verificar-cedula', (req, res) => {
  const { cedula } = req.query;
  db.query('SELECT id_usuario FROM usuarios WHERE cedula = ?', [cedula], (err, results) => {
    if (err) return res.status(500).json({ error: 'Error en la consulta' });

    if (results.length > 0) {
      res.json({ existe: true, id_usuario: results[0].id_usuario });
    } else {
      res.json({ existe: false });
    }
  });
});

// Verificar si correo existe
router.get('/verificar-correo', (req, res) => {
  const { email } = req.query;
  db.query('SELECT id_usuario FROM usuarios WHERE correo = ?', [email], (err, results) => {
    if (err) return res.status(500).json({ error: 'Error en la consulta' });

    if (results.length > 0) {
      res.json({ existe: true, id_usuario: results[0].id_usuario });
    } else {
      res.json({ existe: false });
    }
  });
});

// Exporta el router por defecto
export default router;
