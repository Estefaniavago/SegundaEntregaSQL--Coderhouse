-- 1. Vista de mascotas disponibles para adopción
CREATE OR REPLACE VIEW v_mascotas_disponibles AS
SELECT 
    m.id_mascota,
    m.nombre AS 'Nombre de la mascota',
    m.especie,
    m.raza,
    m.sexo,
    m.fecha_ingreso AS 'Fecha de ingreso al refugio',
    r.nombre AS 'Nombre del refugio',
    r.direccion AS 'Dirección del refugio',
    r.telefono AS 'Teléfono del refugio'
FROM 
    Mascota m
JOIN 
    Refugio r ON m.id_refugio = r.id_refugio
WHERE 
    m.estado_adopcion = 'Disponible';
    
   
-- 2. Vista de mascotas adoptadas
CREATE OR REPLACE VIEW v_mascotas_adoptadas AS
SELECT 
    m.id_mascota,
    m.nombre AS nombre_mascota,
    m.especie,
    m.raza,
    m.fecha_ingreso,
    sa.fecha_solicitud AS fecha_adopcion,
    a.nombre AS nombre_adoptante,
    a.dni AS dni_adoptante,
    a.telefono AS telefono_adoptante
FROM 
    Mascota m
JOIN SolicitudAdopcion sa ON m.id_mascota = sa.id_mascota
JOIN Adoptante a ON sa.id_adoptante = a.id_adoptante
WHERE 
    m.estado_adopcion = 'Adoptado';
     
-- 3. Vista de donaciones por refugio
CREATE OR REPLACE VIEW v_donaciones_por_refugio AS
SELECT 
    r.id_refugio,
    r.nombre AS nombre_refugio,
    COUNT(d.id_donacion) AS 'Cantidad de donaciones',
    SUM(d.monto) AS 'Total recaudado',
    AVG(d.monto) AS 'Promedio por donacion'
FROM 
    Refugio r
LEFT JOIN 
    Donacion d ON r.id_refugio = d.id_refugio
GROUP BY 
    r.id_refugio, r.nombre;
 
 -- 4 - Vista de solicitudes pendientes, es decir aquellas que están en análisis.
 CREATE OR REPLACE VIEW v_solicitudes_pendientes AS
SELECT 
    s.id_solicitud,
    s.fecha_solicitud,
    a.nombre AS nombre_adoptante,
    a.dni,
    a.telefono AS telefono_adoptante,
    a.email AS email_adoptante,
    m.nombre AS nombre_mascota,
    m.especie,
    m.raza
FROM 
    SolicitudAdopcion s
JOIN 
    Adoptante a ON s.id_adoptante = a.id_adoptante
JOIN 
    Mascota m ON s.id_mascota = m.id_mascota
WHERE 
    s.estado = 'Pendiente';
 
-- 5- Vista Historial médico de las mascotas

CREATE OR REPLACE VIEW v_historial_medico AS
SELECT 
    m.id_mascota,
    m.nombre AS nombre_mascota,
    v.nombre AS nombre_veterinario,
    v.matricula,
    c.fecha_consulta,
    c.motivo,
    c.tratamiento
FROM 
    ConsultaVeterinaria c
JOIN 
    Mascota m ON c.id_mascota = m.id_mascota
JOIN 
    Veterinario v ON c.id_veterinario = v.id_veterinario
ORDER BY 
    m.id_mascota, c.fecha_consulta DESC;
 
-- 6- Vista seguimiento adopciones recientes
CREATE OR REPLACE VIEW v_seguimiento_adopciones AS 
SELECT 
    sg.id_seguimiento,
    sa.fecha_solicitud,
    m.nombre AS nombre_mascota,
    a.nombre AS nombre_adoptante,
    sg.fecha_visita,
    sg.observaciones,
    m.estado_adopcion,
    sg.estado_mascota
FROM 
    SolicitudAdopcion sa
JOIN 
    Seguimiento sg ON sa.id_solicitud = sg.id_solicitud
JOIN 
    Mascota m ON sa.id_mascota = m.id_mascota
JOIN 
    Adoptante a ON sa.id_adoptante = a.id_adoptante
WHERE 
     sa.fecha_solicitud >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY 
    sg.fecha_visita DESC;
    
select * from v_seguimiento_adopciones;
 
 