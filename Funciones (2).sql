-- 1. Funcion que calcula el total de las donaciones por refugio ingresado
DELIMITER //

CREATE FUNCTION fn_total_donaciones_refugio(p_id_refugio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(monto)
    INTO total
    FROM Donacion
    WHERE id_refugio = p_id_refugio;

    RETURN IFNULL(total, 0.00);
END;
//

DELIMITER ;

-- 2. Función que cuenta mascotas por refugio según su estado de adopción

DELIMITER //

CREATE FUNCTION fn_mascotas_por_estado(p_id_refugio INT, p_estado ENUM('Disponible', 'Adoptado', 'En seguimiento'))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;

    SELECT COUNT(*)
    INTO cantidad
    FROM Mascota
    WHERE id_refugio = p_id_refugio AND estado_adopcion = p_estado;

    RETURN cantidad;
END;
//

DELIMITER ;

-- 3. Función para contar mascotas por refugio

DELIMITER //
CREATE FUNCTION fn_contar_mascotas_por_refugio(p_id_refugio INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
        SELECT COUNT(*) INTO total
        FROM Mascota
        WHERE id_refugio = p_id_refugio;
    
    RETURN total;
END //
DELIMITER ;

-- 4. Función que devuelve la cantidad de visitas que se realizaron en cada cado para el seguimiento
DELIMITER //

CREATE FUNCTION fn_cantidad_visitas_seguimiento(p_id_solicitud INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE visitas INT;

    SELECT COUNT(*)
    INTO visitas
    FROM Seguimiento
    WHERE id_solicitud = p_id_solicitud;

    RETURN visitas;
END;
//

DELIMITER ;

-- 5. Función para contar consultas al veterninario de cada mascota

DELIMITER //

CREATE FUNCTION fn_consultas_por_mascota(p_id_mascota INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;

    SELECT COUNT(*)
    INTO cantidad
    FROM ConsultaVeterinaria
    WHERE id_mascota = p_id_mascota;

    RETURN cantidad;
END;
//

DELIMITER ;

-- 6. Función para verificar disponibilidad de una mascota

DELIMITER //
CREATE FUNCTION fn_disponibilidad_mascota(p_id_mascota INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE estado_actual VARCHAR(20);
    
    SELECT estado_adopcion INTO estado_actual
    FROM Mascota
    WHERE id_mascota = p_id_mascota;
    
    IF estado_actual = 'Disponible' THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //
DELIMITER ;
