-- 1. Stored Procedure que permite actualizar el estado de una solitud de adopcion y el estado de la mascota

DELIMITER //

CREATE PROCEDURE sp_registrar_solicitud_adopcion (
    IN p_fecha DATE,
    IN p_id_adoptante INT,
    IN p_id_mascota INT
)
BEGIN
    INSERT INTO SolicitudAdopcion (fecha_solicitud, estado, id_adoptante, id_mascota)
    VALUES (p_fecha, 'Pendiente', p_id_adoptante, p_id_mascota);
    
    -- Actualizar estado de la mascota a "En seguimiento"
    UPDATE Mascota
    SET estado_adopcion = 'En seguimiento'
    WHERE id_mascota = p_id_mascota;
END;
//

DELIMITER ;
-- 2. Stored procedure actualizacion de la confirmacion de adopcion

DELIMITER //

CREATE PROCEDURE sp_confirmar_adopcion (
    IN p_id_solicitud INT,
    IN p_fecha DATE,
    IN p_exito BOOLEAN,
    IN p_observaciones TEXT
)
BEGIN
    INSERT INTO ConfirmacionAdopcion (id_solicitud, fecha_confirmacion, exito, observaciones)
    VALUES (p_id_solicitud, p_fecha, p_exito, p_observaciones);

    IF p_exito THEN
        UPDATE Mascota
        SET estado_adopcion = 'Adoptado'
        WHERE id_mascota = (
            SELECT id_mascota FROM SolicitudAdopcion WHERE id_solicitud = p_id_solicitud
        );
    ELSE
        UPDATE Mascota
        SET estado_adopcion = 'Disponible'
        WHERE id_mascota = (
            SELECT id_mascota FROM SolicitudAdopcion WHERE id_solicitud = p_id_solicitud
        );
    END IF;

    -- Actualizar estado de la solicitud
    UPDATE SolicitudAdopcion
    SET estado = IF(p_exito, 'Aprobada', 'Cancelada')
    WHERE id_solicitud = p_id_solicitud;
END;
//

DELIMITER ;

-- 3. Stored procedure para cargar visita al vetrinario
DELIMITER //

CREATE PROCEDURE sp_registrar_consulta_veterinaria_por_nombres (
    IN p_nombre_mascota VARCHAR(50),
    IN p_nombre_veterinario VARCHAR(100),
    IN p_fecha DATE,
    IN p_motivo TEXT,
    IN p_tratamiento TEXT
)
BEGIN
    DECLARE v_id_mascota INT;
    DECLARE v_id_veterinario INT;

    -- Buscar ID de la mascota por nombre
    SELECT id_mascota INTO v_id_mascota
    FROM Mascota
    WHERE nombre = p_nombre_mascota
    LIMIT 1;

    -- Si no se encuentra la mascota
    IF v_id_mascota IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mascota no encontrada con ese nombre';
    END IF;

    -- Buscar ID del veterinario por nombre
    SELECT id_veterinario INTO v_id_veterinario
    FROM Veterinario
    WHERE nombre = p_nombre_veterinario
    LIMIT 1;

    -- Si no se encuentra el veterinario
    IF v_id_veterinario IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Veterinario no encontrado con ese nombre';
    END IF;

    -- Registrar la consulta
    INSERT INTO ConsultaVeterinaria (id_mascota, id_veterinario, fecha_consulta, motivo, tratamiento)
    VALUES (v_id_mascota, v_id_veterinario, p_fecha, p_motivo, p_tratamiento);
END;
//

DELIMITER ;

-- 4. Stored pocedure que genera reporte de adopciones
DELIMITER //
CREATE PROCEDURE sp_generar_reporte_adopciones(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    SELECT 
        r.nombre AS refugio,
        COUNT(sa.id_solicitud) AS total_adopciones,
        SUM(CASE WHEN m.especie = 'Perro' THEN 1 ELSE 0 END) AS perros,
        SUM(CASE WHEN m.especie = 'Gato' THEN 1 ELSE 0 END) AS gatos,
        SUM(CASE WHEN m.especie NOT IN ('Perro', 'Gato') THEN 1 ELSE 0 END) AS otros
    FROM 
        SolicitudAdopcion sa
        JOIN Mascota m ON sa.id_mascota = m.id_mascota
        JOIN Refugio r ON m.id_refugio = r.id_refugio
    WHERE 
        sa.estado = 'Aprobada'
        AND sa.fecha_solicitud BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY 
        r.nombre
    ORDER BY 
        total_adopciones DESC;
END //
DELIMITER ;