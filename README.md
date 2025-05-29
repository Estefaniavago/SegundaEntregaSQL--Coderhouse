# SEGUNDA ENTREGA - SQL - ESTEFANIA VAGO

## Vistas para el Sistema de Refugios de Animales

A continuación se presenta un listado de las vistas que se consideran relevantes para facilitar el acceso a la información, mejorar la seguridad de los datos, y simplificar las consultas frecuentes dentro del sistema.

### Vista `v_mascotas_disponibles`

**Objetivo:** Mostrar todas las mascotas disponibles para adopción con información relevante.

**Tablas que la componen:**

- Mascota  
- Refugio

**Descripción:**  
Esta vista filtra las mascotas con estado `'Disponible'` y muestra información de la mascota y del refugio donde se encuentran, facilitando la búsqueda para potenciales adoptantes.

---

### Vista `v_mascotas_adoptadas`

**Objetivo:** Listar todas las mascotas que han sido adoptadas con información de su adoptante.

**Tablas que la componen:**

- Mascota  
- Adoptante

**Descripción:**  
Muestra el historial de adopciones exitosas, incluyendo datos de la mascota, fecha de adopción e información del adoptante. Es útil para reportes y seguimientos.

---

### Vista `v_donaciones_por_refugio`

**Objetivo:** Resumir las donaciones recibidas por cada refugio.

**Tablas que la componen:**

- Donación  
- Refugio

**Descripción:**  
Agrupa las donaciones por refugio, mostrando totales y promedios. Ayuda en la gestión financiera de los refugios.

---

### Vista `v_solicitudes_pendientes`

**Objetivo:** Proporcionar información detallada de todas las solicitudes de adopción pendientes de aprobación.

**Tablas involucradas:**

- SolicitudAdopcion  
- Adoptante  
- Mascota

**Descripción:**  
Permite al personal del refugio revisar fácilmente las solicitudes pendientes con toda la información relevante proveniente de distintas tablas.

---

### Vista `v_historial_medico`

**Objetivo:** Mostrar el historial médico completo de todas las mascotas.

**Tablas involucradas:**

- ConsultaVeterinaria  
- Mascota  
- Veterinario

**Descripción:**  
Proporciona un registro completo de las consultas veterinarias para cada mascota.

---

### Vista `v_seguimiento_adopciones`

**Objetivo:** Monitorear los seguimientos realizados a las adopciones aprobadas en los últimos 6 meses.

**Tablas involucradas:**

- Seguimiento  
- SolicitudAdopcion  
- Mascota  
- Adoptante

**Descripción:**  
Asegura el bienestar de las mascotas mediante el seguimiento de adopciones recientes.

---

## Funciones para el Sistema de Refugios de Animales

### Función `fn_total_donaciones_refugio`

**Objetivo:** Obtener un resumen financiero por refugio.

**Tablas involucradas:**

- Donaciones

**Descripción:**  
Calcula el monto total de donaciones recibidas por un refugio específico.

---

### Función `fn_mascotas_por_estado`

**Objetivo:** Controlar el estado de adopción de las mascotas por refugio.

**Tablas involucradas:**

- Mascota

**Descripción:**  
Cuenta cuántas mascotas hay en un refugio según su estado de adopción (Disponible, Adoptado, etc.).

---

### Función `fn_contar_mascotas_por_refugio`

**Objetivo:** Conocer la cantidad de mascotas que fueron albergadas en cada refugio.

**Tablas involucradas:**

- Mascota

**Descripción:**  
Cuenta el número de mascotas que fueron albergadas históricamente en un refugio específico.

---

### Función `fn_cantidad_visitas_seguimiento`

**Objetivo:** Evaluar el control post-adopción.

**Tablas involucradas:**

- Seguimiento

**Descripción:**  
Devuelve la cantidad de visitas de seguimiento realizadas para una solicitud de adopción específica.

---

### Función `fn_consultas_por_mascota`

**Objetivo:** Llevar registro del historial clínico veterinario.

**Tablas involucradas:**

- ConsultaVeterinaria

**Descripción:**  
Devuelve la cantidad de consultas veterinarias realizadas para una mascota.

---

### Función `fn_disponibilidad_mascota`

**Objetivo:** Evitar conflictos al procesar solicitudes de adopción para mascotas que ya no están disponibles.

**Tablas involucradas:**

- Mascota

**Descripción:**  
Verifica si una mascota específica está disponible para adopción.

---

## Stored Procedures para el Sistema de Refugios de Animales

### Stored Procedure `sp_registrar_solicitud_adopcion`

**Objetivo:** Automatizar la carga de nuevas solicitudes, garantizando la integridad y asociando adoptante y mascota. También modifica el estado de la mascota a ‘En seguimiento’.

**Tablas involucradas:**

- SolicitudAdopcion

**Descripción:**  
Registra una nueva solicitud de adopción de una mascota.

---

### Stored Procedure `sp_confirmar_adopcion`

**Objetivo:** Consolidar el proceso de adopción y reflejar el estado final de la mascota.

**Tablas involucradas:**

- ConfirmacionAdopcion  
- Mascota

**Descripción:**  
Registra la confirmación de adopción y actualiza el estado de la mascota y de la solicitud si la adopción no se concreta.

---

### Stored Procedure `sp_registrar_consulta_veterinaria_por_nombres`

**Objetivo:** Facilitar la carga de consultas sin requerir IDs, usando datos más intuitivos para el usuario (nombre de mascota y nombre de veterinario).

**Tablas involucradas:**

- ConsultaVeterinaria  
- Mascota  
- Veterinario

**Descripción:**  
Registra una nueva consulta veterinaria buscando los IDs de la mascota y del veterinario a partir de sus nombres.

---

### Stored Procedure `sp_generar_reporte_adopciones`

**Objetivo:** Producir un reporte consolidado con métricas de adopciones aprobadas por refugio en un período específico, clasificando las mascotas por especie para análisis estratégico.

**Tablas involucradas:**

- SolicitudAdopcion  
- Mascota  
- Refugio

**Descripción:**  
Genera un reporte ejecutivo que muestra:
- Total de adopciones por refugio  
- Desglose por especies (perros, gatos y otros)
