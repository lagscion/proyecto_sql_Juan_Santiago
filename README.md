# JUAN SANTIAGO LAGOS JAIMES 

# Sistema de Gestión Inmobiliaria - Base de Datos MySQL

Prototipo de base de datos relacional robusto y optimizado para la gestión integral de un portafolio inmobiliario. El sistema administra el inventario de inmuebles, registro de clientes, contratación, historial de pagos, auditoría automatizada y reportes mensuales de cartera.

---

## 📋 Tabla de Contenidos

1. [Características del Sistema](https://www.google.com/search?q=%23-caracter%C3%ADsticas-del-sistema)
2. [Instalación y Configuración](https://www.google.com/search?q=%23-instalaci%C3%B3n-y-configuraci%C3%B3n)
3. [Explicación del Modelo Entidad-Relación (3FN)](https://www.google.com/search?q=%23-explicaci%C3%B3n-del-modelo-entidad-relaci%C3%B3n-3fn)
4. [Roles y Permisos de Usuarios](https://www.google.com/search?q=%23-roles-y-permisos-de-usuarios)
5. [Lógica de Negocio Automática](https://www.google.com/search?q=%23-l%C3%B3gica-de-negocio-autom%C3%A1tica)
6. [Ejemplos de Consultas y Uso](https://www.google.com/search?q=%23-ejemplos-de-consultas-y-uso)

---

## 🚀 Características del Sistema

* **Normalización en 3FN:** Reducción de redundancia e integridad referencial garantizada.
* **Funciones Almacenadas (UDF):** Métricas de disponibilidad, cálculo dinámico de comisiones y saldo deudor.
* **Triggers de Auditoría:** Rastreabilidad automática ante cambios críticos en contratos e inmuebles.
* **Eventos Programados:** Generación mensual automatizada de reportes de pagos pendientes.
* **Optimización Indexada:** Índices B-Tree en columnas clave para garantizar consultas de alta velocidad.
* **Seguridad Basada en Roles:** Esquema de privilegios diferenciado (`admin`, `agente`, `contador`).

---

## 🛠️ Instalación y Configuración

### Requisitos Previos

* MySQL Server 8.0+ o MariaDB 10.5+
* Cliente MySQL (DBeaver, MySQL Workbench o CLI)

### Pasos de Despliegue

1. **Clonar o descargar el script SQL:**
Asegúrate de contar con el archivo del script de la base de datos `proyecto.sql`.
2. **Ejecutar el script en el servidor MySQL:**
Desde la terminal ejecute el siguiente comando:
```bash
mysql -u root -p < proyecto.sql

```


*O cargue y ejecute todo el contenido del script directamente desde DBeaver o MySQL Workbench.*
3. **Verificar el Scheduler de Eventos:**
El script activa automáticamente el programador de eventos (`event_scheduler = ON`). Puedes confirmar su estado mediante:
```sql
SHOW VARIABLES LIKE 'event_scheduler';

```



---

## 📐 Explicación del Modelo Entidad-Relación (3FN)

El diseño cumple estrictamente con las reglas de normalización hasta la **Tercera Forma Normal (3FN)**:

* **Primera Forma Normal (1FN):** Todos los atributos son atómicos (e.g., separación de `Nombre` y `Apellido` en `CLIENTES` y `AGENTES`). Cada tabla cuenta con una clave primaria única (`PRIMARY KEY AUTO_INCREMENT`).
* **Segunda Forma Normal (2FN):** Se eliminaron las dependencias parciales. Atributos descriptivos o repetitivos como el rol de un agente o el tipo de propiedad fueron abstraídos a sus propias entidades (`ROLES`, `TIPOS_PROPIEDAD`, `TIPOS_CONTRATO`).
* **Tercera Forma Normal (3FN):** Se eliminaron las dependencias transitivas. Por ejemplo, el porcentaje de comisión depende únicamente del tipo de propiedad (`TIPOS_PROPIEDAD`), no de la fila individual en `PROPIEDADES`. De igual forma, los totales pagados no se almacenan redundantemente en `CONTRATOS`, sino que se calculan dinámicamente mediante funciones.

---

## 🔐 Roles y Permisos de Usuarios

La base de datos implementa tres cuentas con permisos segmentados según el principio de mínimo privilegio:

| Usuario | Contraseña | Privilegios Otorgados |
| --- | --- | --- |
| **`admin`** | `4dm1n_1st` | Acceso total sobre la base de datos `proyecto.*` (`ALL PRIVILEGES WITH GRANT OPTION`). |
| **`agente`** | `Agente_local1` | Lectura y actualización (`SELECT`, `INSERT`, `UPDATE`) en `PROPIEDADES` y `TIPOS_PROPIEDAD`. |
| **`contador`** | `Contador_67_` | Lectura y gestión en `PAGOS`, lectura en `CONTRATOS`, `CLIENTES` y `REPORTE_PAGOS_PENDIENTES`. |

---

## ⚙️ Lógica de Negocio Automática

### Funciones Personalizadas (UDF)

* **`libre(tipe VARCHAR)`**: Retorna la cantidad de propiedades disponibles filtrando por tipo (ej. `'Penthouse'`, `'Apartamento'`).
* **`comision(prop_id INT)`**: Calcula la comisión monetaria que genera un inmueble al multiplicar su valor por el porcentaje configurado en su tipo.
* **`fn_ObtenerDeudaContrato(p_ID_Contrato INT)`**: Resta el total acumulado en `PAGOS` al `Monto_Total` del contrato.

### Triggers y Auditoría

* **`trg_Auditoria_Estado_Propiedad`**: Detecta cambios en la disponibilidad de un inmueble e inserta un registro en `AUDITORIA_PROPIEDADES` con valor anterior, valor nuevo, fecha y usuario.
* **`trg_Auditoria_Nuevo_Contrato`**: Registra en `AUDITORIA_CONTRATOS` el alta de cualquier nuevo contrato firmado.

### Evento Programado

* **`evt_Generar_Reporte_Pagos_Pendientes`**: Se ejecuta el primer día de cada mes calculando automáticamente los contratos con saldo a favor y poblando la tabla `REPORTE_PAGOS_PENDIENTES`.

---

## 🔍 Ejemplos de Consultas y Uso

### 1. Consultar la disponibilidad actual de inmuebles

```sql
-- Obtener cuántos apartamentos están disponibles
SELECT libre('Apartamento') AS Apartamentos_Disponibles;

-- Consultar cuántos penthouses hay listos para arriendo/venta
SELECT libre('Penthouse') AS Penthouses_Disponibles;

```

### 2. Calcular la comisión potencial de una propiedad

```sql
SELECT 
    p.ID_Propiedad, 
    p.Direccion, 
    p.Precio, 
    comision(p.ID_Propiedad) AS Comision_Agente
FROM PROPIEDADES p
WHERE p.ID_Propiedad = 1;

```

### 3. Verificar la deuda pendiente de un contrato de arriendo

```sql
SELECT 
    c.ID_Contrato, 
    cli.Nombre, 
    cli.Apellido, 
    c.Monto_Total, 
    fn_ObtenerDeudaContrato(c.ID_Contrato) AS Deuda_Pendiente
FROM CONTRATOS c
JOIN CLIENTES cli ON c.ID_Cliente = cli.ID_Cliente
WHERE c.ID_Contrato = 4;

```

### 4. Consultar el historial de auditoría de cambios en propiedades

```sql
SELECT 
    ID_AuditoriaProp, 
    ID_Propiedad, 
    Campo_Modificado, 
    Valor_Anterior, 
    Valor_Nuevo, 
    Fecha_Modificacion, 
    Usuario_Modificador
FROM AUDITORIA_PROPIEDADES
ORDER BY Fecha_Modificacion DESC;

```

### 5. Informe consolidado de pagos pendientes por cliente

```sql
SELECT 
    r.Fecha_Generacion, 
    c.ID_Contrato, 
    CONCAT(cli.Nombre, ' ', cli.Apellido) AS Cliente, 
    cli.Telefono, 
    r.Monto_Pendiente
FROM REPORTE_PAGOS_PENDIENTES r
JOIN CONTRATOS c ON r.ID_Contrato = c.ID_Contrato
JOIN CLIENTES cli ON c.ID_Cliente = cli.ID_Cliente
WHERE r.Monto_Pendiente > 0
ORDER BY r.Monto_Pendiente DESC;

```
