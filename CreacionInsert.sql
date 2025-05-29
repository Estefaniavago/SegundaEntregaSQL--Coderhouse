-- Eliminacion si ya existe
DROP DATABASE IF EXISTS AdopcionMascotas;

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS AdopcionMascotas;
USE AdopcionMascotas;

-- Tabla Refugio
CREATE TABLE Refugio (
    id_refugio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    direccion VARCHAR(150),
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- Tabla Mascota
CREATE TABLE Mascota (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    especie VARCHAR(30),
    raza VARCHAR(50),
    fecha_nacimiento_estimada VARCHAR(5),  -- formato 'MM-AA' o 'MM/AA'
    sexo ENUM('Macho', 'Hembra'),
    fecha_ingreso DATE,
    estado_adopcion ENUM('Disponible', 'Adoptado', 'En seguimiento'),
    id_refugio INT,
    FOREIGN KEY (id_refugio) REFERENCES Refugio(id_refugio)
);

-- Tabla Adoptante
CREATE TABLE Adoptante (
    id_adoptante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    dni VARCHAR(15),
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(150)
);

-- Tabla SolicitudAdopcion

-- Se deben incluir todos los adoptados como solicitud aprobada, 
-- los pendientes son los que se están analizando 
-- y los cancelados son los que existen incompatibilidades para dar en adopcion 
-- esa mascota a ese adoptante

CREATE TABLE SolicitudAdopcion (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    fecha_solicitud DATE,
    estado ENUM('Pendiente', 'Aprobada','Cancelada'),
    id_adoptante INT,
    id_mascota INT,
    FOREIGN KEY (id_adoptante) REFERENCES Adoptante(id_adoptante),
    FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota)
);

-- Tabla Seguimiento
CREATE TABLE Seguimiento (
    id_seguimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT,
    fecha_visita DATE,
    observaciones TEXT,
    estado_mascota VARCHAR(50),
    FOREIGN KEY (id_solicitud) REFERENCES SolicitudAdopcion(id_solicitud)
);

CREATE TABLE ConfirmacionAdopcion (
    id_confirmacion INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT,
    fecha_confirmacion DATE,
    exito BOOLEAN, -- TRUE si se concretó la adopción, FALSE si no
    observaciones TEXT,
    FOREIGN KEY (id_solicitud) REFERENCES SolicitudAdopcion(id_solicitud)
);

-- Tabla Veterinario
CREATE TABLE Veterinario (
    id_veterinario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    matricula VARCHAR(30),
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- Tabla ConsultaVeterinaria
CREATE TABLE ConsultaVeterinaria (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_mascota INT,
    id_veterinario INT,
    fecha_consulta DATE,
    motivo TEXT,
    tratamiento TEXT,
    FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota),
    FOREIGN KEY (id_veterinario) REFERENCES Veterinario(id_veterinario)
);

-- Tabla Donacion
CREATE TABLE Donacion (
    id_donacion INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    monto DECIMAL(10,2),
    donante_nombre VARCHAR(100),
    id_refugio INT,
    FOREIGN KEY (id_refugio) REFERENCES Refugio(id_refugio)
);

-- Inserciones en tabla efugio
INSERT INTO Refugio (nombre, direccion, telefono, email) VALUES
('Refugio Esperanza', 'Calle 123, Neuquén', '2994123456', 'esperanza@refugios.org'),
('Hogar Patitas Felices', 'Av. Siempreviva 742, Cipolletti', '2994765432', 'patitas@refugios.org'),
('Refugio San Roque', 'Boulevard Mitre 950, Centenario', '2994876543', 'sanroque@refugios.org'),
('Ayuda Animal', 'Calle Roca 321, Plottier', '2994112233', 'ayudaanimal@refugios.org'),
('Refugio El Arca', 'Ruta 7, km 25, Neuquén', '2994987654', 'elarca@refugios.org'),
('Refugio Huellitas del Sur', 'Los Pinos 450, Zapala', '2994332211', 'huellitas@refugios.org'),
('Amor Animal', 'Montevideo 200, Cutral Co', '2994223344', 'amoranimal@refugios.org'),
('Refugio Pampa Libre', 'Av. del Trabajador 850, Neuquén', '2994445566', 'pampalibre@refugios.org'),
('Alas de Libertad', 'Av. Argentina 950, Neuquén', '2994778899', 'alas@refugios.org'),
('Manos Amigas', 'Calle 10 N°123, Centenario', '2994667788', 'manosamigas@refugios.org');

-- Inserciones en tabla mascota
INSERT INTO Mascota (nombre, especie, raza, fecha_nacimiento_estimada, sexo, fecha_ingreso, estado_adopcion, id_refugio) VALUES
('Tina', 'Perro', 'Mestizo', '01-24', 'Hembra', '2024-04-20', 'Disponible', 6),
('Zeus', 'Perro', 'Pastor Alemán', '04-20', 'Macho', '2024-04-21', 'Adoptado', 7),
('Kira', 'Gato', 'Mestizo', '01-24', 'Hembra', '2024-04-22', 'Disponible', 8),
('Max', 'Perro', 'Mestizo', '09-21', 'Macho', '2024-04-23', 'Disponible', 9),
('Lili', 'Gato', 'Persa', '11-23', 'Hembra', '2024-04-24', 'Disponible', 10),
('Nico', 'Perro', 'Mestizo', '07-19', 'Macho', '2024-04-25', 'En seguimiento', 6),
('Gala', 'Gato', 'Mestizo', '10-22', 'Hembra', '2024-04-26', 'Disponible', 7),
('Cholo', 'Perro', 'Shar Pei', '04-20', 'Macho', '2024-04-27', 'Adoptado', 8),
('Sami', 'Perro', 'Mestizo', '02-23', 'Hembra', '2024-04-28', 'Disponible', 9),
('Fiona', 'Gato', 'Europeo', '12-23', 'Hembra', '2024-04-29', 'Disponible', 10),
('Luna', 'Perro', 'Labrador', '01-22', 'Hembra', '2024-01-10', 'Disponible', 1),
('Simba', 'Gato', 'Siamés', '02-23', 'Macho', '2024-02-15', 'Adoptado', 1),
('Toby', 'Perro', 'Mestizo', '03-20', 'Macho', '2024-03-01', 'En seguimiento', 2),
('Milo', 'Gato', 'Mestizo', '11-21', 'Macho', '2024-01-20', 'Disponible', 3),
('Duna', 'Perro', 'Golden Retriever', '04-24', 'Hembra', '2024-04-01', 'Disponible', 1),
('Nina', 'Gato', 'Mestizo', '02-22', 'Hembra', '2024-02-05', 'Adoptado', 4),
('Rocky', 'Perro', 'Pitbull', '01-19', 'Macho', '2024-01-30', 'En seguimiento', 2),
('Pelusa', 'Gato', 'Angora', '03-23', 'Hembra', '2024-03-20', 'Disponible', 3),
('Chispa', 'Perro', 'Beagle', '03-23', 'Hembra', '2024-03-05', 'Disponible', 1),
('Tommy', 'Perro', 'Boxer', '02-20', 'Macho', '2024-02-25', 'Adoptado', 5),
('Maya', 'Gato', 'Siberiano', '04-22', 'Hembra', '2024-04-03', 'Disponible', 5),
('Bruno', 'Perro', 'Mestizo', '03-21', 'Macho', '2024-03-15', 'Disponible', 2),
('Lola', 'Gato', 'Mestizo', '03-23', 'Hembra', '2024-03-12', 'Adoptado', 3),
('Boby', 'Perro', 'Mestizo', '01-18', 'Macho', '2024-01-18', 'Disponible', 4),
('Cleo', 'Gato', 'Europeo', '02-22', 'Hembra', '2024-02-14', 'Disponible', 5),
('Rita', 'Perro', 'Caniche', '05-23', 'Hembra', '2024-05-01', 'Disponible', 6),
('Thor', 'Perro', 'Dálmata', '06-22', 'Macho', '2024-05-02', 'En seguimiento', 7),
('Mimi', 'Gato', 'Bengala', '02-24', 'Hembra', '2024-05-03', 'Disponible', 8),
('Pipo', 'Perro', 'Mestizo', '08-20', 'Macho', '2024-05-04', 'Adoptado', 9),
('Cata', 'Gato', 'Mestizo', '09-21', 'Hembra', '2024-05-05', 'Disponible', 10),
('Lolo', 'Perro', 'Salchicha', '10-22', 'Macho', '2024-05-06', 'Disponible', 6),
('Nala', 'Gato', 'Mestizo', '11-23', 'Hembra', '2024-05-07', 'En seguimiento', 7),
('Benji', 'Perro', 'Mestizo', '12-21', 'Macho', '2024-05-08', 'Disponible', 8),
('Sasha', 'Gato', 'Azul Ruso', '01-24', 'Hembra', '2024-05-09', 'Disponible', 9),
('Roco', 'Perro', 'Bulldog', '02-22', 'Macho', '2024-05-10', 'Adoptado', 10),
('Rocky', 'Perro', 'Husky Siberiano', '05-22', 'Macho', '2024-05-11', 'Disponible', 1),
('Maggie', 'Perro', 'Bulldog Inglés', '09-21', 'Hembra', '2024-05-12', 'Adoptado', 2),
('Coco', 'Gato', 'Mestizo', '08-23', 'Macho', '2024-05-13', 'Disponible', 3),
('Toby', 'Perro', 'Dálmata', '07-22', 'Macho', '2024-05-14', 'En seguimiento', 4),
('Luna', 'Gato', 'Persa', '12-21', 'Hembra', '2024-05-15', 'Disponible', 5),
('Simba', 'Perro', 'Pastor Belga', '06-20', 'Macho', '2024-05-16', 'Disponible', 6),
('Mila', 'Gato', 'Mestizo', '04-24', 'Hembra', '2024-05-17', 'Adoptado', 7),
('Leo', 'Perro', 'Golden Retriever', '03-23', 'Macho', '2024-05-18', 'Disponible', 8),
('Nina', 'Gato', 'Siamés', '10-22', 'Hembra', '2024-05-19', 'En seguimiento', 9),
('Rex', 'Perro', 'Beagle', '11-21', 'Macho', '2024-05-20', 'Disponible', 10),
('Suri', 'Gato', 'Bengala', '01-23', 'Hembra', '2024-05-21', 'Disponible', 1),
('Chico', 'Perro', 'Mestizo', '02-22', 'Macho', '2024-05-22', 'Adoptado', 2),
('Kika', 'Gato', 'Europeo', '09-23', 'Hembra', '2024-05-23', 'Disponible', 3),
('Balto', 'Perro', 'Husky Siberiano', '08-20', 'Macho', '2024-05-24', 'Disponible', 4),
('Mona', 'Gato', 'Angora', '07-22', 'Hembra', '2024-05-25', 'En seguimiento', 5);

-- Inserción tabla adoptantes
INSERT INTO Adoptante (nombre, dni, telefono, email, direccion) VALUES
('María González', '30111222', '2994789456', 'maria.g@gmail.com', 'San Martín 555, Neuquén'),
('Juan Pérez', '28444999', '2994120000', 'juan.p@gmail.com', 'Belgrano 321, Cipolletti'),
('Andrea Salazar', '32222444', '2994781001', 'andrea.sal@gmail.com', 'Chubut 300, Plottier'),
('Luciano Méndez', '30888777', '2994115588', 'luciano.men@gmail.com', 'San Juan 999, Neuquén'),
('Camila Herrera', '31333333', '2994000111', 'camila.h@gmail.com', 'Roca 122, Centenario'),
('Santiago Ríos', '29777888', '2994667890', 'santi.rios@gmail.com', 'Ruta 22 km 5, Plottier'),
('Julieta Gaitán', '30444555', '2994129876', 'julieta.gaitan@gmail.com', 'Catamarca 234, Neuquén'),
('Matías Vidal', '28999000', '2994555555', 'matias.v@gmail.com', 'Formosa 321, Cipolletti'),
('Rocío Delgado', '31222777', '2994111122', 'rocio.d@gmail.com', 'Chaco 765, Neuquén'),
('Pablo Fernández', '28666111', '2994008765', 'pablo.f@gmail.com', 'Misiones 987, Plottier'),
('Sofía Castro', '32200123', '2994780012', 'sofia.c@gmail.com', 'Santa Cruz 210, Centenario'),
('Tomás López', '29444123', '2994660011', 'tomas.lopez@gmail.com', 'Entre Ríos 188, Neuquén'),
('Valentina Díaz', '31231001', '2994765001', 'valen.d@gmail.com', 'Corrientes 456, Cipolletti'),
('Diego Navarro', '30555999', '2994777888', 'diego.nav@gmail.com', 'Jujuy 321, Plottier'),
('Agustina Romero', '30119987', '2994900000', 'agustina.r@gmail.com', 'La Pampa 643, Centenario'),
('Lucas Benítez', '29888777', '2994991234', 'lucas.benitez@gmail.com', 'Italia 654, Neuquén'),
('Carla Funes', '31444777', '2994001222', 'carla.funes@gmail.com', '25 de Mayo 876, Cipolletti'),
('Ignacio Ruíz', '28666222', '2994113344', 'ignacio.ruiz@gmail.com', 'Perito Moreno 300, Plottier'),
('Florencia Soto', '29999888', '2994556677', 'flor.soto@gmail.com', 'Rio Negro 444, Centenario'),
('Mariano Campos', '31334444', '2994000990', 'mariano.campos@gmail.com', 'Tucumán 789, Neuquén'),
('Belén Acosta', '30333444', '2994998765', 'belen.acosta@gmail.com', 'Buenos Aires 120, Cipolletti'),
('Federico Molina', '29555111', '2994783322', 'fede.molina@gmail.com', 'Neuquén 456, Plottier'),
('Martina Suárez', '31000999', '2994667899', 'martina.suarez@gmail.com', 'Santa Fe 222, Neuquén'),
('Emilia Vargas', '30011223', '2994005678', 'emilia.vargas@gmail.com', 'Av. Argentina 890, Centenario'),
('Bruno Cabrera', '29000112', '2994789432', 'bruno.cabrera@gmail.com', 'Los Álamos 345, Plottier'),
('Martín López', '30777666', '2994782233', 'martin.lopez@gmail.com', 'San Luis 123, Neuquén'),
('Ana Morales', '29999222', '2994664455', 'ana.morales@gmail.com', 'Chubut 456, Cipolletti'),
('Gonzalo Torres', '30445566', '2994123344', 'gonzalo.torres@gmail.com', 'Río Colorado 789, Plottier'),
('Paula Vega', '31122334', '2994998877', 'paula.vega@gmail.com', 'Neuquén 234, Centenario'),
('Diego Ruiz', '28888999', '2994007766', 'diego.ruiz@gmail.com', 'Maipú 654, Neuquén'),
('Valeria Martínez', '30556677', '2994553344', 'valeria.martinez@gmail.com', 'Avenida 9 de Julio 123, Plottier'),
('Sebastián Ortega', '29887766', '2994112233', 'sebastian.ortega@gmail.com', 'Las Heras 789, Cipolletti'),
('Gabriela Díaz', '30339988', '2994781122', 'gabriela.diaz@gmail.com', 'Roca 101, Centenario'),
('Javier Morales', '29112233', '2994669988', 'javier.morales@gmail.com', 'Patagonia 234, Neuquén'),
('Clara Figueroa', '31002233', '2994004455', 'clara.figueroa@gmail.com', 'Mitre 567, Plottier');

-- Insercion tabla solicitudAdopcion

-- Eliminar registros existentes para evitar duplicados (opcional, solo si es necesario)
-- DELETE FROM SolicitudAdopcion;

-- Inserciones corregidas para la tabla SolicitudAdopcion
INSERT INTO SolicitudAdopcion (fecha_solicitud, estado, id_adoptante, id_mascota) VALUES
-- Solicitudes aprobadas (mascotas ya adoptadas)
('2025-01-15', 'Aprobada', 1, 2),   
('2025-02-10', 'Aprobada', 3, 8),   
('2025-03-05', 'Aprobada', 5, 12), 
('2025-04-01', 'Aprobada', 7, 16),  
('2025-04-15', 'Aprobada', 9, 20),  
('2025-05-05', 'Aprobada', 11, 23), 
('2025-05-10', 'Aprobada', 13, 29), 
('2025-05-20', 'Aprobada', 15, 35), 
('2025-05-22', 'Aprobada', 17, 37), 
('2025-05-25', 'Aprobada', 19, 42), 
('2025-05-25', 'Aprobada', 2, 47), 

-- Mascotas en seguimiento (Solicitud debió ser aprobada para ir al seguimiento)
('2025-05-05', 'Aprobada', 21, 6),  
('2025-05-08', 'Aprobada', 22, 13), 
('2025-05-10', 'Aprobada', 23, 17), 
('2025-05-12', 'Aprobada', 24, 27), 
('2025-05-14', 'Aprobada', 25, 32), 
('2025-05-16', 'Aprobada', 26, 39), 
('2025-05-18', 'Aprobada', 27, 44), 
('2025-05-20', 'Aprobada', 28, 50), 

-- Solicitudes canceladas (incompatibilidades)
('2025-01-20', 'Cancelada', 2, 1),   -- Tina (Juan Pérez - incompatibilidad)
('2025-02-15', 'Cancelada', 4, 11),  -- Luna (Luciano Méndez - incompatibilidad)
('2025-03-10', 'Cancelada', 6, 15),  -- Duna (Santiago Ríos - incompatibilidad)
('2025-04-05', 'Cancelada', 8, 19),  -- Chispa (Matías Vidal - incompatibilidad)
('2025-05-01', 'Cancelada', 10, 25), -- Boby (Pablo Fernández - incompatibilidad)

-- Solicitudes pendientes (en análisis) para mascotas disponibles
('2025-05-18', 'Pendiente', 12, 4),  
('2025-05-19', 'Pendiente', 14, 7),  
('2025-05-21', 'Pendiente', 16, 10), 
('2025-05-23', 'Pendiente', 18, 22), 
('2025-05-24', 'Pendiente', 20, 24); -

-- Insercion Tabla Segumiento. Se genera un segumiento una vez que la mascota tiene una solicitud aprobada

-- Seguimientos para mascotas ya adoptadas (solicitudes aprobadas)

INSERT INTO Seguimiento (id_solicitud, fecha_visita, observaciones, estado_mascota) VALUES
-- Seguimiento para mascota 2 (Zeus)
(1, '2025-01-20', 'Primera visita: mascota se adapta bien al nuevo hogar', 'Excelente'),
(1, '2025-02-15', 'Segunda visita: mascota con buen peso y comportamiento', 'Muy bueno'),
(1, '2025-03-20', 'Visita final: adopción confirmada con éxito', 'Perfecto'),

-- Seguimiento para mascota 8 (Cholo)
(2, '2025-02-15', 'Primera visita: mascota un poco nerviosa pero se está adaptando', 'Bueno'),
(2, '2025-03-15', 'Segunda visita: mejoró su comportamiento, ya está cómodo', 'Muy bueno'),
(2, '2025-04-15', 'Visita final: adopción confirmada con éxito', 'Excelente'),

-- Seguimiento para mascota 12 (Simba)
(3, '2025-03-10', 'Primera visita: gato algo asustadizo pero come bien', 'Bueno'),
(3, '2025-04-10', 'Segunda visita: ya explora la casa con confianza', 'Muy bueno'),
(3, '2025-05-10', 'Visita final: adopción confirmada con éxito', 'Excelente'),

-- Seguimiento para mascota 16 (Nina)
(4, '2025-04-05', 'Primera visita: perra juguetona, se lleva bien con la familia', 'Excelente'),
(4, '2025-05-05', 'Segunda visita: comportamiento ejemplar', 'Perfecto'),
(4, '2025-06-05', 'Visita final: adopción confirmada con éxito', 'Perfecto'),

-- Seguimiento para mascota 20 (Tommy)
(5, '2025-04-20', 'Primera visita: perro fuerte pero obediente, buen comportamiento', 'Muy bueno'),
(5, '2025-05-20', 'Segunda visita: excelente adaptación', 'Excelente'),
(5, '2025-06-20', 'Visita final: adopción confirmada con éxito', 'Perfecto'),

-- Seguimiento para mascota 23 (Lola)
(6, '2025-05-10', 'Primera visita: gata tranquila, se adapta bien', 'Bueno'),
(6, '2025-06-10', 'Segunda visita: excelente relación con los dueños', 'Excelente'),
(6, '2025-07-10', 'Visita final: adopción confirmada con éxito', 'Perfecto'),

-- Seguimiento para mascota 29 (Pipo)
(7, '2025-05-15', 'Primera visita: perro mayor pero activo, buen estado', 'Bueno'),
(7, '2025-06-15', 'Segunda visita: sigue en buen estado de salud', 'Muy bueno'),
(7, '2025-07-15', 'Visita final: adopción confirmada con éxito', 'Excelente'),

-- Seguimiento para mascota 35 (Mila)
(8, '2025-05-25', 'Primera visita: gatita tímida pero cariñosa', 'Bueno'),
(8, '2025-06-25', 'Segunda visita: más sociable, buen apetito', 'Muy bueno'),
(8, '2025-07-25', 'Visita final: adopción confirmada con éxito', 'Excelente'),

-- Seguimiento para mascota 37 (Coco)
(9, '2025-05-27', 'Primera visita: perro juguetón, buen estado físico', 'Excelente'),
(9, '2025-06-27', 'Segunda visita: comportamiento ejemplar', 'Perfecto'),
(9, '2025-07-27', 'Visita final: adopción confirmada con éxito', 'Perfecto'),

-- Seguimiento para mascota 42 (Balto)
(10, '2025-05-30', 'Primera visita: perro activo, necesita mucho ejercicio', 'Bueno'),
(10, '2025-06-30', 'Segunda visita: se adaptó al ritmo de la familia', 'Muy bueno'),
(10, '2025-07-30', 'Visita final: adopción confirmada con éxito', 'Excelente'),

-- Seguimiento para mascota 47 (Chico)
(11, '2025-05-30', 'Primera visita: perro tranquilo, buen comportamiento', 'Muy bueno'),
(11, '2025-06-30', 'Segunda visita: excelente relación con los niños', 'Excelente'),
(11, '2025-07-30', 'Visita final: adopción confirmada con éxito', 'Perfecto'),

-- Seguimientos en curso para mascotas en proceso de adopción

-- Seguimiento para mascota 6 (Nico)
(12, '2025-05-10', 'Primera visita: perro algo ansioso, necesita tiempo', 'Regular'),
(12, '2025-06-10', 'Segunda visita: mejora en el comportamiento', 'Bueno'),

-- Seguimiento para mascota 13 (Milo)
(13, '2025-05-13', 'Primera visita: gato tímido, se esconde mucho', 'Regular'),
(13, '2025-06-13', 'Segunda visita: algo más sociable', 'Bueno'),

-- Seguimiento para mascota 17 (Rocky)
(14, '2025-05-15', 'Primera visita: perro fuerte, necesita más entrenamiento', 'Regular'),
(14, '2025-06-15', 'Segunda visita: responde bien al entrenamiento', 'Bueno'),

-- Seguimiento para mascota 27 (Thor)
(15, '2025-05-17', 'Primera visita: perro energético, necesita más espacio', 'Regular'),
(15, '2025-06-17', 'Segunda visita: mejorando con el ejercicio diario', 'Bueno'),

-- Seguimiento para mascota 32 (Nina)
(16, '2025-05-21', 'Primera visita: gata algo territorial', 'Regular'),
(16, '2025-06-21', 'Segunda visita: mejorando la convivencia', 'Bueno'),

-- Seguimiento para mascota 39 (Mona)
(17, '2025-05-23', 'Primera visita: gata mayor, necesita adaptación', 'Regular'),
(17, '2025-06-23', 'Segunda visita: más cómoda en el entorno', 'Bueno'),

-- Seguimiento para mascota 44 (Kika)
(18, '2025-05-25', 'Primera visita: gata asustadiza', 'Regular'),
(18, '2025-06-25', 'Segunda visita: poco progreso, sigue nerviosa', 'Regular'),

-- Seguimiento para mascota 50 (Mona)
(19, '2025-05-25', 'Primera visita: gata mayor con necesidades especiales', 'Regular'),
(19, '2025-06-25', 'Segunda visita: adaptación lenta pero progresiva', 'Regular'),

-- Seguimientos no exitosos (adopciones canceladas)

-- Seguimiento cancelado para mascota 1 (Tina)
(20, '2025-01-25', 'Primera visita: perra no se adapta al hogar, mucho estrés', 'Malo'),
(20, '2025-02-05', 'Visita final: decisión de cancelar la adopción', 'Muy malo'),

-- Seguimiento cancelado para mascota 3 (Kira)
(21, '2025-02-20', 'Primera visita: gata no se lleva con otras mascotas del hogar', 'Malo'),
(21, '2025-03-01', 'Visita final: adopción cancelada por incompatibilidad', 'Malo'),

-- Seguimiento cancelado para mascota 4 (Max)
(22, '2025-03-15', 'Primera visita: perro muestra agresividad con niños', 'Malo'),
(22, '2025-03-25', 'Visita final: adopción cancelada por seguridad', 'Muy malo'),

-- Seguimiento cancelado para mascota 28 (Mimi)
(23, '2025-05-10', 'Primera visita: gata no usa arenero correctamente', 'Regular'),
(23, '2025-05-20', 'Visita final: adopción cancelada por problemas de comportamiento', 'Malo'),

-- Seguimiento cancelado para mascota 36 (Leo)
(24, '2025-05-23', 'Primera visita: perro destruye mobiliario por ansiedad', 'Malo'),
(24, '2025-06-02', 'Visita final: adopción cancelada por daños', 'Muy malo'),

-- Seguimiento cancelado para mascota 41 (Suri)
(25, '2025-05-26', 'Primera visita: gata no tolera a los niños', 'Malo'),
(25, '2025-06-05', 'Visita final: adopción cancelada por seguridad', 'Malo');


-- Inserciones en la tabla confirmacion. Aquellas mascotas que pasan a estado: 'Adoptado'
 
INSERT INTO ConfirmacionAdopcion (id_solicitud, fecha_confirmacion, exito, observaciones) VALUES
(1, '2025-03-25', TRUE, 'Adopción de Zeus confirmada con éxito'),
(2, '2025-04-20', TRUE, 'Adopción de Cholo confirmada con éxito'),
(3, '2025-05-15', TRUE, 'Adopción de Simba confirmada con éxito'),
(4, '2025-06-10', TRUE, 'Adopción de Chispa confirmada con éxito'),
(5, '2025-06-25', TRUE, 'Adopción de Tommy confirmada con éxito'),
(6, '2025-07-15', TRUE, 'Adopción de Lola confirmada con éxito'),
(7, '2025-07-20', TRUE, 'Adopción de Pipo confirmada con éxito'),
(8, '2025-07-30', TRUE, 'Adopción de Mila confirmada con éxito'),
(9, '2025-08-02', TRUE, 'Adopción de Coco confirmada con éxito'),
(10, '2025-08-05', TRUE, 'Adopción de Balto confirmada con éxito'),
(11, '2025-08-05', TRUE, 'Adopción de Chico confirmada con éxito');
-- Inserciones para la tabla Veterinario
INSERT INTO Veterinario (nombre, matricula, telefono, email) VALUES
('Dra. Laura Méndez', 'MP-1234', '2994123456', 'laura.mendez@vetpatagonia.com'),
('Dr. Carlos Rojas', 'MP-2345', '2994234567', 'carlos.rojas@vetpatagonia.com'),
('Dra. Ana Belén Torres', 'MP-3456', '2994345678', 'ana.torres@clinicaveterinaria.com'),
('Dr. Javier Soto', 'MP-4567', '2994456789', 'javier.soto@clinicaveterinaria.com'),
('Dra. Sofía Núñez', 'MP-5678', '2994567890', 'sofia.nunez@vetneuquen.com'),
('Dr. Marcos Díaz', 'MP-6789', '2994678901', 'marcos.diaz@vetneuquen.com'),
('Dra. Valeria Castro', 'MP-7890', '2994789012', 'valeria.castro@animalcare.com'),
('Dr. Nicolás Herrera', 'MP-8901', '2994890123', 'nicolas.herrera@animalcare.com'),
('Dra. Patricia López', 'MP-9012', '2994901234', 'patricia.lopez@vetpuppies.com'),
('Dr. Fernando Gutiérrez', 'MP-0123', '2994012345', 'fernando.gutierrez@vetpuppies.com'),
('Dra. Gabriela Ruiz', 'MP-1122', '2994123457', 'gabriela.ruiz@vetexpress.com'),
('Dr. Alejandro Molina', 'MP-2233', '2994234568', 'alejandro.molina@vetexpress.com'),
('Dra. Mariana Vega', 'MP-3344', '2994345679', 'mariana.vega@vetfamily.com'),
('Dr. Lucas Pereyra', 'MP-4455', '2994456790', 'lucas.pereyra@vetfamily.com'),
('Dra. Carolina Fernández', 'MP-5566', '2994567801', 'carolina.fernandez@vetplus.com');

-- Insercion en tabla ConsultaVeternianrias

-- Consultas veterinarias iniciales para todas las mascotas 
INSERT INTO ConsultaVeterinaria (id_mascota, id_veterinario, fecha_consulta, motivo, tratamiento) VALUES
-- Mascotas del refugio 1
(11, 1, '2025-01-11', 'Examen inicial de ingreso', 'Desparasitación, vacuna antirrábica y plan sanitario básico'),
(12, 2, '2025-02-16', 'Chequeo inicial', 'Vacunación completa y castración programada'),
(15, 3, '2025-04-02', 'Primer examen', 'Control de peso, desparasitación y vacunas al día'),
(19, 4, '2025-03-06', 'Evaluación inicial', 'Tratamiento antipulgas y plan de alimentación'),
(36, 5, '2025-05-12', 'Consulta de ingreso', 'Revisión general, vacuna quíntuple y microchip'),

-- Mascotas del refugio 2
(3, 6, '2025-03-02', 'Primera consulta', 'Desparasitación y evaluación de comportamiento'),
(17, 7, '2025-01-31', 'Examen inicial', 'Tratamiento para hongos en piel y vacunación'),
(23, 8, '2025-02-26', 'Chequeo de ingreso', 'Castración y limpieza dental'),
(32, 9, '2025-05-13', 'Evaluación inicial', 'Control de peso y plan nutricional'),
(37, 10, '2025-05-18', 'Primera consulta', 'Vacunación y desparasitación interna'),

-- Mascotas del refugio 3
(4, 11, '2025-01-21', 'Examen de ingreso', 'Tratamiento para garrapatas y vacunas'),
(18, 12, '2025-03-21', 'Consulta inicial', 'Control de oídos y plan de vacunación'),
(24, 13, '2025-03-13', 'Primer examen', 'Castración y tratamiento antiparasitario'),
(38, 14, '2025-05-14', 'Chequeo inicial', 'Revisión general y microchip'),

-- Mascotas del refugio 4
(6, 15, '2025-01-19', 'Consulta de ingreso', 'Tratamiento para sarna y recuperación nutricional'),
(25, 1, '2025-02-15', 'Examen inicial', 'Vacunación y control de peso'),
(34, 2, '2025-05-15', 'Primera consulta', 'Desparasitación y evaluación dental'),

-- Mascotas del refugio 5
(5, 3, '2025-02-06', 'Chequeo inicial', 'Control de vacunas y esterilización'),
(26, 4, '2025-05-02', 'Examen de ingreso', 'Tratamiento para alergia alimentaria'),
(39, 5, '2025-05-16', 'Primera consulta', 'Vacunación y plan de ejercicios'),

-- Mascotas del refugio 6
(1, 6, '2025-04-21', 'Consulta inicial', 'Control general y desparasitación'),
(27, 7, '2025-05-03', 'Examen de ingreso', 'Tratamiento para infección ocular'),
(31, 8, '2025-05-07', 'Primer chequeo', 'Vacunación y castración programada'),

-- Mascotas del refugio 7
(2, 9, '2025-04-22', 'Evaluación inicial', 'Plan sanitario completo y microchip'),
(28, 10, '2025-05-04', 'Consulta de ingreso', 'Tratamiento para dermatitis'),
(33, 11, '2025-05-08', 'Primer examen', 'Control de peso y vacunas'),

-- Mascotas del refugio 8
(7, 12, '2025-04-27', 'Chequeo inicial', 'Desparasitación y evaluación nutricional'),
(29, 13, '2025-05-05', 'Examen de ingreso', 'Tratamiento para resfriado felino'),

-- Mascotas del refugio 9
(8, 14, '2025-04-28', 'Consulta inicial', 'Vacunación y control de parásitos'),
(30, 15, '2025-05-06', 'Primer chequeo', 'Evaluación de comportamiento'),

-- Mascotas del refugio 10
(9, 1, '2025-04-29', 'Examen de ingreso', 'Plan sanitario completo'),
(10, 2, '2025-05-01', 'Consulta inicial', 'Tratamiento para obesidad y dieta especial'),

-- Consultas adicionales para mascotas con problemas de salud
(6, 3, '2025-02-10', 'Seguimiento tratamiento sarna', 'Nueva aplicación de medicamento y baño medicinal'),
(17, 4, '2025-02-15', 'Control hongos en piel', 'Cambio de medicación y crema antifúngica'),
(26, 5, '2025-05-10', 'Control alergia alimentaria', 'Cambio a dieta hipoalergénica y seguimiento'),
(28, 6, '2025-05-15', 'Revisión dermatitis', 'Mejoría notable, continuar tratamiento por 1 semana más'),
(29, 7, '2025-05-12', 'Control resfriado felino', 'Medicación ajustada, mejoría evidente');

-- Insercion en tabla donaciones
INSERT INTO Donacion (fecha, monto, donante_nombre, id_refugio) VALUES
-- Donaciones al Refugio Esperanza (id 1)
('2025-01-15', 5000.00, 'Empresa PetFood S.A.', 1),
('2025-03-22', 2500.00, 'Juan Pérez', 1),
('2025-05-10', 10000.00, 'Fundación Ayuda Animal', 1),

-- Donaciones al Hogar Patitas Felices (id 2)
('2025-02-18', 3000.00, 'María González', 2),
('2025-04-05', 7500.00, 'Veterinaria San Roque', 2),

-- Donaciones al Refugio San Roque (id 3)
('2025-01-30', 2000.00, 'Carlos Rodríguez', 3),
('2025-03-15', 4500.00, 'Tienda Mascotas Felices', 3),

-- Donaciones a Ayuda Animal (id 4)
('2025-02-10', 6000.00, 'Asociación Protectora Neuquén', 4),
('2025-04-20', 3500.00, 'Andrea López', 4),

-- Donaciones al Refugio El Arca (id 5)
('2025-01-25', 4000.00, 'Supermercado La Anónima', 5),
('2025-05-05', 8000.00, 'Empresa Constructora Patagonia', 5),

-- Donaciones al Refugio Huellitas del Sur (id 6)
('2025-03-10', 1500.00, 'Escuela Primaria N°12', 6),
('2025-05-15', 5000.00, 'Club de Leones Zapala', 6),

-- Donaciones a Amor Animal (id 7)
('2025-02-28', 3000.00, 'Farmacia Central', 7),
('2025-04-18', 6500.00, 'Luis Martínez', 7),

-- Donación a Refugio Pampa Libre (id 8)
('2025-03-05', 7000.00, 'Rotary Club Neuquén', 8),

-- Donación a Alas de Libertad (id 9)
('2025-01-20', 2500.00, 'Grupo Scout Sol Argentino', 9),

-- Donación a Manos Amigas (id 10)
('2025-04-30', 9000.00, 'Cooperativa Eléctrica Centenario', 10),

-- Donación especial para todos los refugios
('2025-05-20', 15000.00, 'Gobierno de la Provincia del Neuquén', 1),
('2025-05-20', 15000.00, 'Gobierno de la Provincia del Neuquén', 2),
('2025-05-20', 15000.00, 'Gobierno de la Provincia del Neuquén', 3),
('2025-05-20', 15000.00, 'Gobierno de la Provincia del Neuquén', 4),
('2025-05-20', 15000.00, 'Gobierno de la Provincia del Neuquén', 5),
('2025-05-20', 15000.00, 'Gobierno de la Provincia del Neuquén', 6),
('2025-05-20', 15000.00, 'Gobierno de la Provincia del Neuquén', 7),
('2025-05-20', 15000.00, 'Gobierno de la Provincia del Neuquén', 8),
('2025-05-20', 15000.00, 'Gobierno de la Provincia del Neuquén', 9),
('2025-05-20', 15000.00, 'Gobierno de la Provincia del Neuquén', 10);
