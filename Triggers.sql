DELIMITER //

CREATE TRIGGER trg_actualizar_estado_mascota_despues_de_confirmacion
AFTER INSERT ON ConfirmacionAdopcion
FOR EACH ROW
BEGIN
    DECLARE v_id_mascota INT;

    IF NEW.exito = TRUE THEN
        -- Obtener id_mascota desde la solicitud
        SELECT id_mascota INTO v_id_mascota
        FROM SolicitudAdopcion
        WHERE id_solicitud = NEW.id_solicitud;

        -- Actualizar el estado de adopción de la mascota
        UPDATE Mascota
        SET estado_adopcion = 'Adoptado'
        WHERE id_mascota = v_id_mascota;
    END IF;
END;
//

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_fecha_ingreso_automatica
BEFORE INSERT ON Mascota
FOR EACH ROW
BEGIN
    IF NEW.fecha_ingreso IS NULL THEN
        SET NEW.fecha_ingreso = CURDATE();
    END IF;
END;
//

DELIMITER ;