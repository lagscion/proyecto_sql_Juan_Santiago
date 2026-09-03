drop database proyecto;
	
	  CREATE DATABASE IF NOT EXISTS proyecto;
	  
	  USE proyecto;
	
	SET FOREIGN_KEY_CHECKS = 0;

	DROP TABLE IF EXISTS ROLES;
	CREATE TABLE ROLES (
	    ID_Rol      INT AUTO_INCREMENT PRIMARY KEY,
	    Nombre      VARCHAR(100) NOT NULL,
	    Descripcion VARCHAR(255)
	);
	

	DROP TABLE IF EXISTS TIPOS_PROPIEDAD;
	CREATE TABLE TIPOS_PROPIEDAD (
	    ID_TipoPropiedad INT AUTO_INCREMENT PRIMARY KEY,
	    NombreTipo       VARCHAR(100) NOT null,
	    comision  decimal (10, 2)
	);
	

	DROP TABLE IF EXISTS TIPOS_CONTRATO;
	CREATE TABLE TIPOS_CONTRATO (
	    ID_TipoContrato     INT AUTO_INCREMENT PRIMARY KEY,
	    NombreTipoContrato  VARCHAR(100) NOT NULL
	);
	

	DROP TABLE IF EXISTS CLIENTES;
	CREATE TABLE CLIENTES (
	    ID_Cliente     INT AUTO_INCREMENT PRIMARY KEY,
	    Nombre         VARCHAR(100) NOT NULL,
	    Apellido       VARCHAR(100) NOT NULL,
	    Email          VARCHAR(150),
	    Telefono       VARCHAR(20),
	    Direccion      VARCHAR(255),
	    Fecha_Registro DATE
	);
	

	DROP TABLE IF EXISTS AGENTES;
	CREATE TABLE AGENTES (
	    ID_Agente         INT AUTO_INCREMENT PRIMARY KEY,
	    Nombre            VARCHAR(100) NOT NULL,
	    Apellido          VARCHAR(100) NOT NULL,
	    Email             VARCHAR(150),
	    Telefono          VARCHAR(20),
	    ID_Rol            INT NOT NULL,
	    Fecha_Contratacion DATE,
	    CONSTRAINT FK_Agentes_Rol
	        FOREIGN KEY (ID_Rol) REFERENCES ROLES(ID_Rol)
	);
	

	DROP TABLE IF EXISTS PROPIEDADES;
	CREATE TABLE PROPIEDADES (
	    ID_Propiedad          INT AUTO_INCREMENT PRIMARY KEY,
	    Direccion             VARCHAR(255) NOT NULL,
	    Ciudad                VARCHAR(100),
	    Estado                VARCHAR(100),
	    Codigo_Postal         VARCHAR(20),
	    ID_TipoPropiedad      INT NOT NULL,
	    ID_Agente_Asignado    INT NOT NULL,
	    Precio                DECIMAL(15,2),
	    Habitaciones          INT,
	    Banos                 INT,
	    Superficie_m2         INT,
	    Estado_Disponibilidad varchar(20),
	    CONSTRAINT FK_Propiedades_TipoPropiedad
	        FOREIGN KEY (ID_TipoPropiedad) REFERENCES TIPOS_PROPIEDAD(ID_TipoPropiedad),
	    CONSTRAINT FK_Propiedades_Agente
	        FOREIGN KEY (ID_Agente_Asignado) REFERENCES AGENTES(ID_Agente)
	);
	

	DROP TABLE IF EXISTS AUDITORIA_PROPIEDADES;
	CREATE TABLE AUDITORIA_PROPIEDADES (
	    ID_AuditoriaProp   INT AUTO_INCREMENT PRIMARY KEY,
	    ID_Propiedad       INT NOT NULL,
	    Campo_Modificado   VARCHAR(100),
	    Valor_Anterior     VARCHAR(255),
	    Valor_Nuevo        VARCHAR(255),
	    Fecha_Modificacion DATE,
	    Usuario_Modificador VARCHAR(100),
	    CONSTRAINT FK_AuditoriaProp_Propiedad
	        FOREIGN KEY (ID_Propiedad) REFERENCES PROPIEDADES(ID_Propiedad)
	);
	

	DROP TABLE IF EXISTS CONTRATOS;
	CREATE TABLE CONTRATOS (
	    ID_Contrato       INT AUTO_INCREMENT PRIMARY KEY,
	    ID_Propiedad      INT NOT NULL,
	    ID_Cliente        INT NOT NULL,
	    ID_Agente_Vendedor INT NOT NULL,
	    ID_TipoContrato   INT NOT NULL,
	    Fecha_Inicio      DATE,
	    Fecha_Fin         DATE,
	    Monto_Total       DECIMAL(15,2),
	    Estado_Contrato   varchar(20),
	    CONSTRAINT FK_Contratos_Propiedad
	        FOREIGN KEY (ID_Propiedad) REFERENCES PROPIEDADES(ID_Propiedad),
	    CONSTRAINT FK_Contratos_Cliente
	        FOREIGN KEY (ID_Cliente) REFERENCES CLIENTES(ID_Cliente),
	    CONSTRAINT FK_Contratos_Agente
	        FOREIGN KEY (ID_Agente_Vendedor) REFERENCES AGENTES(ID_Agente),
	    CONSTRAINT FK_Contratos_TipoContrato
	        FOREIGN KEY (ID_TipoContrato) REFERENCES TIPOS_CONTRATO(ID_TipoContrato)
	);
	

	DROP TABLE IF EXISTS PAGOS;
	CREATE TABLE PAGOS (
	    ID_Pago       INT AUTO_INCREMENT PRIMARY KEY,
	    ID_Contrato   INT NOT NULL,
	    Fecha_Pago    DATE,
	    Monto_Pagado  DECIMAL(15,2),
	    Metodo_Pago   VARCHAR(50),
	    CONSTRAINT FK_Pagos_Contrato
	        FOREIGN KEY (ID_Contrato) REFERENCES CONTRATOS(ID_Contrato)
	);
	

	DROP TABLE IF EXISTS AUDITORIA_CONTRATOS;
	CREATE TABLE AUDITORIA_CONTRATOS (
	    ID_AuditoriaContr  INT AUTO_INCREMENT PRIMARY KEY,
	    ID_Contrato        INT NOT NULL,
	    Campo_Modificado   VARCHAR(100),
	    Valor_Anterior     VARCHAR(255),
	    Valor_Nuevo        VARCHAR(255),
	    Fecha_Modificacion DATE,
	    Usuario_Modificador VARCHAR(100),
	    CONSTRAINT FK_AuditoriaContr_Contrato
	        FOREIGN KEY (ID_Contrato) REFERENCES CONTRATOS(ID_Contrato)
	);
	

	DROP TABLE IF EXISTS REPORTE_PAGOS_PENDIENTES;
	CREATE TABLE REPORTE_PAGOS_PENDIENTES (
	    ID_Reporte        INT AUTO_INCREMENT PRIMARY KEY,
	    ID_Contrato       INT NOT NULL,
	    Monto_Pendiente   DECIMAL(15,2),
	    Fecha_Generacion  DATE,
	    CONSTRAINT FK_ReportePagos_Contrato
	        FOREIGN KEY (ID_Contrato) REFERENCES CONTRATOS(ID_Contrato)
	);
	
	SET FOREIGN_KEY_CHECKS = 1;
	
	

	
	SET FOREIGN_KEY_CHECKS = 0;
	
	-- ---------------------------------------------------------
	-- 1. POBLAR ROLES (10 registros)
	-- ---------------------------------------------------------
	TRUNCATE TABLE ROLES;
	INSERT INTO ROLES (Nombre, Descripcion) VALUES
	('Agente Comercial', 'Encargado de la captación y negociación con clientes.'),
	('Agente Senior', 'Agente con alta experiencia especializado en inmuebles de lujo.'),
	('Administrador', 'Acceso total a la plataforma y gestión de usuarios.'),
	('Gestor de Contratos', 'Supervisa la legalidad, firmas y condiciones contractuales.'),
	('Coordinador de Alquileres', 'Especialista en la gestión de inmuebles para arrendamiento.'),
	('Asesor Financiero', 'Evalúa créditos hipotecarios y capacidad crediticia de clientes.'),
	('Soporte / Recepción', 'Atención inicial a clientes e ingreso de requerimientos.'),
	('Supervisor de Auditoría', 'Revisa logs de cambios en contratos y propiedades.'),
	('Director de Ventas', 'Supervisa metas del equipo comercial e informes globales.'),
	('Gestor de Cobranzas', 'Encargado del seguimiento y recuperación de pagos pendientes.');
	
	-- ---------------------------------------------------------
	-- 2. POBLAR TIPOS_PROPIEDAD (10 registros)
	-- ---------------------------------------------------------
	TRUNCATE TABLE TIPOS_PROPIEDAD;
	INSERT INTO TIPOS_PROPIEDAD (NombreTipo, comision) VALUES
	('Apartamento', 20.0),
	('Casa Campestre', 1.25),
	('Penthouse', 1.24),
	('Local Comercial', 2.1),
	('Oficina', 1.25),
	('Bodega / Nivel Industrial', 0.5),
	('Lote / Terreno', 3.0),
	('Cabaña', 1.5),
	('Dúplex', 0.5),
	('Edificio de Rentas', 0.23);
	
	-- ---------------------------------------------------------
	-- 3. POBLAR TIPOS_CONTRATO (10 registros)
	-- ---------------------------------------------------------
	TRUNCATE TABLE TIPOS_CONTRATO;
	INSERT INTO TIPOS_CONTRATO (NombreTipoContrato) VALUES
	('Venta Directa'),
	('Arrendamiento Residencial'),
	('Arrendamiento Comercial'),
	('Venta con Hipoteca'),
	('Alquiler Opción Compra'),
	('Derecho de Superficie'),
	('Cesión de Derechos'),
	('Arrendamiento Temporal / Vacacional'),
	('Comodato Comercial'),
	('Administración Delegada');
	
	-- ---------------------------------------------------------
	-- 4. POBLAR CLIENTES (10 registros)
	-- ---------------------------------------------------------
	TRUNCATE TABLE CLIENTES;
	INSERT INTO CLIENTES (Nombre, Apellido, Email, Telefono, Direccion, Fecha_Registro) VALUES
	('Carlos', 'Mendoza', 'carlos.mendoza@email.com', '3001234567', 'Calle 45 # 12-34, Bogotá', '2023-01-15'),
	('María', 'Rodríguez', 'maria.rodriguez@email.com', '3109876543', 'Carrera 15 # 88-10, Medellín', '2023-02-20'),
	('Andrés', 'Gómez', 'andres.gomez@email.com', '3155551234', 'Avenida 6N # 22-05, Cali', '2023-03-10'),
	('Laura', 'Martínez', 'laura.martinez@email.com', '3187778899', 'Calle 72 # 53-12, Barranquilla', '2023-04-05'),
	('Javier', 'Hernández', 'javier.hernandez@email.com', '3014443322', 'Diagonal 32 # 14-50, Bucaramanga', '2023-05-12'),
	('Sofia', 'López', 'sofia.lopez@email.com', '3123334455', 'Calle 10 # 5-20, Cartagena', '2023-06-18'),
	('Diego', 'Morales', 'diego.morales@email.com', '3162221100', 'Carrera 23 # 45-67, Manizales', '2023-07-22'),
	('Valentina', 'Castro', 'valentina.castro@email.com', '3048889911', 'Calle 50 # 30-15, Pereira', '2023-08-30'),
	('Fernando', 'Vargas', 'fernando.vargas@email.com', '3116667788', 'Carrera 9 # 100-20, Cúcuta', '2023-09-14'),
	('Camila', 'Rojas', 'camila.rojas@email.com', '3179990011', 'Avenida Circunvalar # 12-80, Santa Marta', '2023-10-01');
	
	-- ---------------------------------------------------------
	-- 5. POBLAR AGENTES (10 registros - Relacionados con ROLES)
	-- ---------------------------------------------------------
	TRUNCATE TABLE AGENTES;
	INSERT INTO AGENTES (Nombre, Apellido, Email, Telefono, ID_Rol, Fecha_Contratacion) VALUES
	('Alejandro', 'Torres', 'a.torres@inmobiliaria.com', '3009991111', 1, '2021-03-15'),
	('Beatriz', 'Suárez', 'b.suarez@inmobiliaria.com', '3108882222', 2, '2020-01-10'),
	('Camilo', 'Pérez', 'c.perez@inmobiliaria.com', '3157773333', 1, '2022-05-20'),
	('Diana', 'Ramírez', 'd.ramirez@inmobiliaria.com', '3186664444', 4, '2019-11-01'),
	('Eduardo', 'Sánchez', 'e.sanchez@inmobiliaria.com', '3015555555', 5, '2021-08-12'),
	('Fernanda', 'Díaz', 'f.diaz@inmobiliaria.com', '3124446666', 9, '2018-06-01'),
	('Gabriel', 'Navarro', 'g.navarro@inmobiliaria.com', '3163337777', 6, '2022-02-28'),
	('Helena', 'Ortiz', 'h.ortiz@inmobiliaria.com', '3042228888', 10, '2023-01-10'),
	('Ignacio', 'Silva', 'i.silva@inmobiliaria.com', '3111119999', 8, '2020-09-15'),
	('Jessica', 'Arias', 'j.arias@inmobiliaria.com', '3170001010', 3, '2017-04-18');
	
	-- ---------------------------------------------------------
	-- 6. POBLAR PROPIEDADES (10 registros - Relacionados con TIPOS_PROPIEDAD y AGENTES)
	-- ---------------------------------------------------------
	TRUNCATE TABLE PROPIEDADES;
	INSERT INTO PROPIEDADES (Direccion, Ciudad, Estado, Codigo_Postal, ID_TipoPropiedad, ID_Agente_Asignado, Precio, Habitaciones, Banos, Superficie_m2, Estado_Disponibilidad) VALUES
	('Cra 7 # 120-45 Apt 502', 'Bogotá', 'Cundinamarca', '110111', 1, 1, 450000000.00, 3, 2, 95, 'no_disponible'),
	('Km 5 Vía Llanogrande', 'Riostream', 'Antioquia', '054040', 2, 2, 1200000000.00, 5, 5, 450, 'no_disponible'),
	('Calle 93 # 14-20 Penthouse', 'Bogotá', 'Cundinamarca', '110221', 3, 2, 1850000000.00, 4, 4, 280, 'disponible'),
	('CC El Tesoro Local 104', 'Medellín', 'Antioquia', '050021', 4, 3, 850000000.00, 0, 1, 60, 'disponible'),
	('Torre Empresarial Of. 1201', 'Cali', 'Valle del Cauca', '760001', 5, 5, 320000000.00, 2, 2, 85, 'no_disponible'),
	('Zona Franca Bodega 8', 'Barranquilla', 'Atlántico', '080001', 6, 1, 2100000000.00, 0, 3, 1200, 'no_disponible'),
	('Lote Campestre Parcelación A', 'Bucaramanga', 'Santander', '680003', 7, 3, 290000000.00, 0, 0, 800, 'disponible'),
	('Vía Rodadero Cabaña 12', 'Santa Marta', 'Magdalena', '470001', 8, 2, 530000000.00, 3, 3, 160, 'no_disponible'),
	('Calle 100 # 19-32 Dúplex 301', 'Bogotá', 'Cundinamarca', '110311', 9, 1, 620000000.00, 3, 3, 130, 'no_disponible'),
	('Av. El Poblado Ed. Renta', 'Medellín', 'Antioquia', '050022', 10, 6, 3500000000.00, 12, 10, 950, 'disponible'),
	('Av. El Poblado Ed. Renta', 'Medellín', 'Antioquia', '050022', 10, 6, 3500000000.00, 12, 10, 950, 'disponible'),
	('Av. El Poblado Ed. Renta', 'Medellín', 'Antioquia', '050022', 10, 6, 3500000000.00, 12, 10, 950, 'disponible'),
	('Torre Empresarial Of. 1201', 'Cali', 'Valle del Cauca', '760001', 5, 5, 320000000.00, 2, 2, 85, 'no_disponible'),
	('Torre Empresarial Of. 1201', 'Cali', 'Valle del Cauca', '760001', 5, 5, 320000000.00, 2, 2, 85, 'no_disponible'),
	('Calle 93 # 14-20 Penthouse', 'Bogotá', 'Cundinamarca', '110221', 3, 2, 1850000000.00, 4, 4, 280, 'disponible'),
	('Cra 7 # 120-45 Apt 502', 'Bogotá', 'Cundinamarca', '110111', 1, 1, 450000000.00, 3, 2, 95, 'no_disponible'),
	('Cra 7 # 120-45 Apt 502', 'Bogotá', 'Cundinamarca', '110111', 1, 1, 450000000.00, 3, 2, 95, 'no_disponible'),
	('CC El Tesoro Local 104', 'Medellín', 'Antioquia', '050021', 4, 3, 850000000.00, 0, 1, 60, 'disponible'),
	('CC El Tesoro Local 104', 'Medellín', 'Antioquia', '050021', 4, 3, 850000000.00, 0, 1, 60, 'disponible')
	;
	
	
	-- ---------------------------------------------------------
	-- 7. POBLAR AUDITORIA_PROPIEDADES (10 registros - Relacionados con PROPIEDADES)
	-- ---------------------------------------------------------
	TRUNCATE TABLE AUDITORIA_PROPIEDADES;
	INSERT INTO AUDITORIA_PROPIEDADES (ID_Propiedad, Campo_Modificado, Valor_Anterior, Valor_Nuevo, Fecha_Modificacion, Usuario_Modificador) VALUES
	(1, 'Precio', '480000000.00', '450000000.00', '2024-01-10', 'admin_sys'),
	(2, 'Estado_Disponibilidad', '2024-06-30', '2026-12-31', '2024-02-15', 'j.arias'),
	(3, 'Precio', '1900000000.00', '1850000000.00', '2024-03-01', 'b.suarez'),
	(4, 'ID_Agente_Asignado', '1', '3', '2024-03-12', 'f.diaz'),
	(5, 'Precio', '350000000.00', '320000000.00', '2024-04-05', 'e.sanchez'),
	(6, 'Superficie_m2', '1100', '1200', '2024-05-20', 'admin_sys'),
	(7, 'Precio', '310000000.00', '290000000.00', '2024-06-11', 'c.perez'),
	(8, 'Estado_Disponibilidad', '2024-12-31', '2026-12-31', '2024-07-01', 'b.suarez'),
	(9, 'Precio', '650000000.00', '620000000.00', '2024-08-15', 'a.torres'),
	(10, 'ID_Agente_Asignado', '2', '6', '2024-09-02', 'admin_sys');
	
	-- ---------------------------------------------------------
	-- 8. POBLAR CONTRATOS (10 registros - Relacionados con PROPIEDADES, CLIENTES, AGENTES, TIPOS_CONTRATO)
	-- ---------------------------------------------------------
	TRUNCATE TABLE CONTRATOS;
	INSERT INTO CONTRATOS (ID_Propiedad, ID_Cliente, ID_Agente_Vendedor, ID_TipoContrato, Fecha_Inicio, Fecha_Fin, Monto_Total, Estado_Contrato) VALUES
	(1, 1, 1, 2, '2024-01-01', '2024-12-31', 36000000.00, 'finalizado'),
	(2, 2, 2, 1, '2024-02-01', '2024-02-15', 1200000000.00, 'finalizado'),
	(3, 3, 2, 5, '2024-03-01', '2025-02-28', 120000000.00, 'finalizado'),
	(4, 4, 3, 3, '2024-04-01', '2027-03-31', 180000000.00, 'activo'),
	(5, 5, 5, 2, '2024-05-01', '2025-04-30', 28800000.00, 'finalizado'),
	(6, 6, 1, 1, '2024-06-01', '2024-06-20', 2100000000.00, 'finalizado'),
	(7, 7, 3, 4, '2024-07-01', '2034-06-30', 290000000.00, 'activo'),
	(8, 8, 2, 8, '2024-08-01', '2024-08-15', 8500000.00, 'finalizado'),
	(9, 9, 1, 2, '2024-09-01', '2025-08-31', 48000000.00, 'finalizado'),
	(10, 10, 6, 10, '2024-10-01', '2029-09-30', 500000000.00, 'activo');
	
	-- ---------------------------------------------------------
	-- 9. POBLAR PAGOS (10 registros - Relacionados con CONTRATOS)
	-- ---------------------------------------------------------
	TRUNCATE TABLE PAGOS;
	INSERT INTO PAGOS (ID_Contrato, Fecha_Pago, Monto_Pagado, Metodo_Pago) VALUES
	(1, '2024-01-05', 3000000.00, 'Transferencia Bancaria'),
	(1, '2024-02-05', 3000000.00, 'Transferencia Bancaria'),
	(2, '2024-02-10', 1200000000.00, 'Cheque de Gerencia'),
	(3, '2024-03-05', 10000000.00, 'Transferencia Bancaria'),
	(4, '2024-04-02', 5000000.00, 'Tarjeta de Crédito'),
	(5, '2024-05-03', 2400000.00, 'Transferencia Bancaria'),
	(6, '2024-06-15', 2100000000.00, 'Consignación Directa'),
	(7, '2024-07-05', 29000000.00, 'Transferencia Bancaria'),
	(8, '2024-08-01', 8500000.00, 'Efectivo'),
	(9, '2024-09-02', 4000000.00, 'PSE');
	
	-- ---------------------------------------------------------
	-- 10. POBLAR AUDITORIA_CONTRATOS (10 registros - Relacionados con CONTRATOS)
	-- ---------------------------------------------------------
	TRUNCATE TABLE AUDITORIA_CONTRATOS;
	INSERT INTO AUDITORIA_CONTRATOS (ID_Contrato, Campo_Modificado, Valor_Anterior, Valor_Nuevo, Fecha_Modificacion, Usuario_Modificador) VALUES
	(1, 'Monto_Total', '35000000.00', '36000000.00', '2024-01-02', 'd.ramirez'),
	(2, 'Fecha_Fin', '2024-02-28', '2024-02-15', '2024-02-05', 'b.suarez'),
	(3, 'ID_TipoContrato', '2', '5', '2024-03-02', 'd.ramirez'),
	(4, 'Monto_Total', '170000000.00', '180000000.00', '2024-04-03', 'c.perez'),
	(5, 'Fecha_Inicio', '2024-05-05', '2024-05-01', '2024-04-28', 'e.sanchez'),
	(6, 'Usuario_Modificador', 'sistema', 'a.torres', '2024-06-02', 'admin_sys'),
	(7, 'Monto_Total', '300000000.00', '290000000.00', '2024-06-25', 'g.navarro'),
	(8, 'Monto_Total', '9000000.00', '8500000.00', '2024-07-28', 'b.suarez'),
	(9, 'Estado_Contrato', '2024-09-01', '2025-08-31', '2024-09-01', 'a.torres'),
	(10, 'ID_Agente_Vendedor', '2', '6', '2024-09-25', 'f.diaz');
	
	-- ---------------------------------------------------------
	-- 11. POBLAR REPORTE_PAGOS_PENDIENTES (10 registros - Relacionados con CONTRATOS)
	-- ---------------------------------------------------------
	TRUNCATE TABLE REPORTE_PAGOS_PENDIENTES;
	INSERT INTO REPORTE_PAGOS_PENDIENTES (ID_Contrato, Monto_Pendiente, Fecha_Generacion) VALUES
	(1, 30000000.00, '2024-09-01'),
	(3, 110000000.00, '2024-09-01'),
	(4, 175000000.00, '2024-09-01'),
	(5, 26400000.00, '2024-09-01'),
	(7, 261000000.00, '2024-09-01'),
	(9, 44000000.00, '2024-09-01'),
	(10, 500000000.00, '2024-09-01'),
	(1, 27000000.00, '2024-10-01'),
	(5, 24000000.00, '2024-10-01'),
	(9, 40000000.00, '2024-10-01');
	
	SET FOREIGN_KEY_CHECKS = 1;
	

	

	
	use proyecto;
	
	-- permisos
	
	
	-- admin
	create user 'admin'@'localhost' identified by '4dm1n_1st'
	
	grant all privileges on proyecto.* to 'admin'@'localhost' with grant option;
	
	-- agente
	create user 'agente'@'localhost' identified by 'Agente_local1'
	
	grant SELECT, INSERT, update on proyecto.propiedades  to 'agente'@'localhost';
	grant SELECT, INSERT, update on proyecto.tipos_propiedad  to 'agente'@'localhost';
	
	-- contador
	
	create user 'contador'@'localhost' identified by 'Contador_67_'
	
	grant SELECT, INSERT, update on proyecto.pagos  to 'contador'@'localhost';
	grant select on proyecto.contratos to 'contador'@'localhost';
	grant select, update on proyecto.propiedades to 'contador'@'localhost';
	grant select on proyecto.reporte_pagos_pendientes  to 'contador'@'localhost';
	grant select on proyecto.clientes  to 'contador'@'localhost';
	
	
	
	  
	
	-- funciones
	
	-- libres en arriendo
	
DELIMITER //
	
	CREATE FUNCTION libre (tipe varchar(30))
	RETURNS int
	DETERMINISTIC
	BEGIN
		declare how int;
		
	select count(tp.NombreTipo ) into how
	from propiedades p 
	join tipos_propiedad tp 
	on p.ID_TipoPropiedad  = tp.ID_TipoPropiedad 
	where p.Estado_Disponibilidad = 'disponible' and tp.NombreTipo = tipe;
		
		RETURN COALESCE(how, 0);
	END //
	
DELIMITER ;
	
	drop function libre
	
	select * from tipos_propiedad tp join propiedades p on tp.ID_TipoPropiedad = p.ID_TipoPropiedad where tp.NombreTipo = 'apartamento' 
	
	select libre('penthouse')
	
	
	
	-- comision 
	
	use proyecto;
	
	
DELIMITER //
	
	CREATE FUNCTION comision (prop_id INT)
	RETURNS DECIMAL(50,2)
	DETERMINISTIC
	BEGIN
		declare valor decimal (50,2);
		
		SELECT (p.Precio * (tp.comision /100))  into valor
		from PROPIEDADES p 
		join TIPOS_PROPIEDAD tp 
		on p.ID_TipoPropiedad   = tp.ID_TipoPropiedad 
		WHERE p.ID_Propiedad = prop_id;
		
		RETURN valor;
	END //
	
DELIMITER ;
	
	SELECT  comision(1)
	
	-- Calcular deuda pendiente en contratos de arriendo.
	
DELIMITER //
	
	CREATE FUNCTION fn_ObtenerDeudaContrato(p_ID_Contrato INT)
	RETURNS DECIMAL(15,2)
	DETERMINISTIC
	READS SQL DATA
	BEGIN
	    DECLARE v_Monto_Total DECIMAL(15,2) DEFAULT 0.00;
	    DECLARE v_Total_Pagado DECIMAL(15,2) DEFAULT 0.00;
	    DECLARE v_Saldo_Pendiente DECIMAL(15,2) DEFAULT 0.00;
	
	    SELECT Monto_Total 
	    INTO v_Monto_Total
	    FROM CONTRATOS 
	    WHERE ID_Contrato = p_ID_Contrato;
	
	    SELECT IFNULL(SUM(Monto_Pagado), 0.00) 
	    INTO v_Total_Pagado
	    FROM PAGOS 
	    WHERE ID_Contrato = p_ID_Contrato;
	
	    SET v_Saldo_Pendiente = v_Monto_Total - v_Total_Pagado;
	
	    RETURN v_Saldo_Pendiente;
	END //
	
DELIMITER ;
	
	SELECT fn_ObtenerDeudaContrato(8) AS Deuda_Pendiente;
	
	
USE proyecto;


-- 1. TRIGGERS 


DROP TRIGGER IF EXISTS trg_Auditoria_Estado_Propiedad;

DELIMITER //

CREATE TRIGGER trg_Auditoria_Estado_Propiedad
AFTER UPDATE ON PROPIEDADES
FOR EACH ROW
BEGIN

    IF OLD.Estado_Disponibilidad <> NEW.Estado_Disponibilidad 
       OR (OLD.Estado_Disponibilidad IS NULL AND NEW.Estado_Disponibilidad IS NOT NULL) THEN
       
        INSERT INTO AUDITORIA_PROPIEDADES (
            ID_Propiedad,
            Campo_Modificado,
            Valor_Anterior,
            Valor_Nuevo,
            Fecha_Modificacion,
            Usuario_Modificador
        ) VALUES (
            NEW.ID_Propiedad,
            'Estado_Disponibilidad',
            OLD.Estado_Disponibilidad,
            NEW.Estado_Disponibilidad,
            CURDATE(),
            CURRENT_USER()
        );
    END IF;
END //

DELIMITER ;


DROP TRIGGER IF EXISTS trg_Auditoria_Nuevo_Contrato;

DELIMITER //

CREATE TRIGGER trg_Auditoria_Nuevo_Contrato
AFTER INSERT ON CONTRATOS
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_CONTRATOS (
        ID_Contrato,
        Campo_Modificado,
        Valor_Anterior,
        Valor_Nuevo,
        Fecha_Modificacion,
        Usuario_Modificador
    ) VALUES (
        NEW.ID_Contrato,
        'Creacion_Contrato',
        NULL,
        CONCAT('Propiedad: ', NEW.ID_Propiedad, ' | Cliente: ', NEW.ID_Cliente, ' | Monto: $', NEW.Monto_Total),
        CURDATE(),
        CURRENT_USER()
    );
END //

DELIMITER ;



-- EVENTO  MENSUAL

-- Habilitar el motor de eventos en MySQL/MariaDB
SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS evt_Generar_Reporte_Pagos_Pendientes;

DELIMITER //

CREATE EVENT evt_Generar_Reporte_Pagos_Pendientes
ON SCHEDULE EVERY 1 MONTH
STARTS '2026-10-01 00:00:00'
DO
BEGIN
    INSERT INTO REPORTE_PAGOS_PENDIENTES (ID_Contrato, Monto_Pendiente, Fecha_Generacion)
    SELECT 
        c.ID_Contrato,
        fn_ObtenerDeudaContrato(c.ID_Contrato) AS Deuda_Pendiente,
        CURDATE()
    FROM CONTRATOS c
    WHERE fn_ObtenerDeudaContrato(c.ID_Contrato) > 0;
END //

DELIMITER ;



-- PRUEBAS 



UPDATE PROPIEDADES 
SET Estado_Disponibilidad = 'arrendada' 
WHERE ID_Propiedad = 3;


SELECT * FROM AUDITORIA_PROPIEDADES ORDER BY ID_AuditoriaProp DESC;


INSERT INTO CONTRATOS (ID_Propiedad, ID_Cliente, ID_Agente_Vendedor, ID_TipoContrato, Fecha_Inicio, Fecha_Fin, Monto_Total, Estado_Contrato) 
VALUES (3, 1, 2, 2, '2026-09-01', '2027-08-31', 15000000.00, 'Activo');

SELECT * FROM AUDITORIA_CONTRATOS ORDER BY ID_AuditoriaContr DESC;


SHOW VARIABLES LIKE 'event_scheduler';
	
	
	
	
	
