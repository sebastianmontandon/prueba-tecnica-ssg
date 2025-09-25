-- ================================================================
-- PROTEUS CRM - ESTRUCTURA DE BASE DE DATOS (PRUEBA T�CNICA)
-- ================================================================
-- Este archivo contiene las tablas principales para la gesti�n de
-- campa�as, gestiones, usuarios y contactos del sistema Proteus CRM.
-- 
-- NOTA: Este archivo est� dise�ado para un proceso de reclutamiento.
-- Las restricciones de clave for�nea (FK) no est�n implementadas 
-- f�sicamente en la BD original por razones de rendimiento y 
-- flexibilidad, pero se documentan aqu� para comprensi�n del dise�o.
-- ================================================================

-- ================================================================
-- M�DULO DE USUARIOS Y PERMISOS
-- ================================================================

-- ----------------------------------------------------------------
-- Tabla: users
-- Prop�sito: Almacena la informaci�n principal de los usuarios del sistema
-- Incluye operadores telef�nicos, supervisores, administradores, etc.
-- ----------------------------------------------------------------
CREATE TABLE `users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `id_tipo` int(4) NOT NULL,                    -- FK hacia users_tipos.id
  `id_estado` int(2) NOT NULL,                  -- FK hacia users_estados.id  
  `id_grupo` int(4) NOT NULL,                   -- FK hacia users_grupos.id
  `id_categoria` int(8) NOT NULL,               -- FK hacia users_categorias.id
  `ci` int(8) NOT NULL,                         -- C�dula de identidad del usuario
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `apellido` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `usuario` char(32) COLLATE utf8_spanish_ci NOT NULL,  -- Login �nico
  `password` text COLLATE utf8_spanish_ci NOT NULL,     -- Hash de la contrase�a
  `id_tipo_escala` int(2) NOT NULL,             -- Relacionado con esquema de comisiones
  PRIMARY KEY (`id`),
  KEY `id_tipo` (`id_tipo`,`id_estado`,`id_grupo`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_estado` (`id_estado`),
  KEY `id_grupo` (`id_grupo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ----------------------------------------------------------------
-- Tabla: users_tipos
-- Prop�sito: Define los tipos de usuario del sistema
-- Ejemplos: Operador, Supervisor, Administrador, etc.
-- ----------------------------------------------------------------
CREATE TABLE `users_tipos` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ----------------------------------------------------------------
-- Tabla: users_estados
-- Prop�sito: Define los estados posibles de un usuario
-- Ejemplos: Activo, Inactivo, Suspendido, etc.
-- ----------------------------------------------------------------
CREATE TABLE `users_estados` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ----------------------------------------------------------------
-- Tabla: users_grupos
-- Prop�sito: Agrupa usuarios por equipos o departamentos
-- Usado para organizaci�n jer�rquica y permisos
-- ----------------------------------------------------------------
CREATE TABLE `users_grupos` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ----------------------------------------------------------------
-- Tabla: users_categorias
-- Prop�sito: Categorizaci�n adicional de usuarios (ej: Senior, Junior)
-- ----------------------------------------------------------------
CREATE TABLE `users_categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoria` char(32) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ================================================================
-- M�DULO DE CONTACTOS
-- ================================================================

-- ----------------------------------------------------------------
-- Tabla: contactos
-- Prop�sito: Almacena la informaci�n personal de los clientes/prospectos
-- Es la entidad central que conecta todas las gestiones y servicios
-- ----------------------------------------------------------------
CREATE TABLE `contactos` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_estado` int(4) NOT NULL,                  -- FK hacia contactos_estado.id
  `id_domicilio` int(10) UNSIGNED NOT NULL,     -- FK hacia domicilios.id
  `id_ocupacion` int(4) NOT NULL,               -- FK hacia ocupaciones.id
  `id_estado_civil` int(2) NOT NULL,            -- FK hacia estados_civiles.id
  `ci` bigint(11) NOT NULL,                     -- C�dula de identidad
  `nombre1` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `nombre2` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `apellido1` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `apellido2` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `fc_nacimiento` int(8) NOT NULL,              -- Fecha en formato YYYYMMDD
  `sexo` char(1) COLLATE utf8_spanish_ci NOT NULL,  -- 'M' o 'F'
  `zurdo` char(1) COLLATE utf8_spanish_ci NOT NULL, -- Para seguros laborales,
  `id_tel_fijo1` int(10) NOT NULL,              -- FK hacia telefonos.id
  `id_tel_fijo2` int(10) NOT NULL,              -- FK hacia telefonos.id
  `id_tel_movil1` int(10) NOT NULL,             -- FK hacia telefonos.id
  `id_tel_movil2` int(10) NOT NULL,             -- FK hacia telefonos.id
  `email` text COLLATE utf8_spanish_ci NOT NULL,
  `id_userinsert` int(10) NOT NULL,             -- FK hacia users.id (quien cre� el registro)
  `id_fuente_dato` int(10) NOT NULL,            -- FK hacia contactos_fuentes_datos.id
  `se_queda` int(1) NOT NULL,                   -- Flag para campa�as de retenci�n
  `timestamp` bigint(14) NOT NULL,              -- Fecha/hora de creaci�n YYYYMMDDhhiiss
  `lastupdate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `mascota` int(1) DEFAULT '0',                 -- Si tiene mascotas (para productos espec�ficos)
  PRIMARY KEY (`id`),
  KEY `id_tel_fijo1` (`id_tel_fijo1`),
  KEY `id_estado` (`id_estado`),
  KEY `id_domicilio` (`id_domicilio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ----------------------------------------------------------------
-- Tabla: contactos_estado
-- Prop�sito: Estados del contacto en el proceso de gesti�n
-- Ejemplos: Prospecto, Cliente, Rechazado, No contactar, etc.
-- ----------------------------------------------------------------
CREATE TABLE `contactos_estado` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ----------------------------------------------------------------
-- Tabla: telefonos
-- Prop�sito: Almacena los n�meros telef�nicos de forma normalizada
-- Se relaciona con contactos a trav�s de los campos id_tel_*
-- ----------------------------------------------------------------
CREATE TABLE `telefonos` (
  `id` bigint(16) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo` int(2) NOT NULL,                       -- 1=Fijo, 2=M�vil
  `numero` bigint(15) UNSIGNED NOT NULL,        -- N�mero sin prefijos ni formatos
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero` (`numero`),
  KEY `tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ================================================================
-- M�DULO DE CAMPA�AS
-- ================================================================

-- ----------------------------------------------------------------
-- Tabla: campaigns
-- Prop�sito: Define las campa�as de marketing/ventas
-- Una campa�a agrupa gestiones con un objetivo com�n
-- ----------------------------------------------------------------
CREATE TABLE `campaigns` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `id_estado` int(4) NOT NULL,                  -- FK hacia campaigns_estados.id
  `codigo` char(16) COLLATE utf8_spanish_ci NOT NULL,   -- C�digo �nico de campa�a
  `nombre` char(64) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish_ci NOT NULL,
  `brokers` text COLLATE utf8_spanish_ci NOT NULL,      -- Lista de usuarios asignados (formato legacy)
  `fc_inicio` int(8) NOT NULL,                  -- Fecha inicio YYYYMMDD
  `fc_final` int(8) NOT NULL,                   -- Fecha fin YYYYMMDD
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `id_estado` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ----------------------------------------------------------------
-- Tabla: campaigns_estados
-- Prop�sito: Estados de las campa�as
-- Ejemplos: Activa, Pausada, Finalizada, Planificada
-- ----------------------------------------------------------------
CREATE TABLE `campaigns_estados` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ================================================================
-- M�DULO DE GESTIONES
-- ================================================================

-- ----------------------------------------------------------------
-- Tabla: gestiones
-- Prop�sito: Registro de cada intento de contacto o gesti�n realizada
-- Es la entidad que conecta usuarios, contactos y campa�as
-- Cada fila representa una llamada, visita o gesti�n espec�fica
-- ----------------------------------------------------------------
CREATE TABLE `gestiones` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `id_tipo` int(4) NOT NULL,                    -- FK hacia gestiones_tipo.id
  `id_campaign` int(6) NOT NULL,                -- FK hacia campaigns.id
  `id_broker` int(4) NOT NULL,                  -- FK hacia users.id (operador asignado)
  `id_contacto` int(10) NOT NULL,               -- FK hacia contactos.id
  `id_resultado` int(4) NOT NULL,               -- FK hacia gestiones_resultado.id -> 0 significa sin resultado
  `notas` text COLLATE utf8_spanish_ci NOT NULL,    -- Observaciones del operador
  `timestamp` char(14) COLLATE utf8_spanish_ci NOT NULL,  -- Fecha/hora YYYYMMDDhhiiss
  `id_tel_fijo1` int(11) NOT NULL,              -- Tel�fono usado en esta gesti�n
  `lastupdate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_contacto` (`id_contacto`),
  KEY `id_tipo` (`id_tipo`),
  KEY `id_campaign` (`id_campaign`),
  KEY `id_broker` (`id_broker`),
  KEY `id_resultado` (`id_resultado`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ----------------------------------------------------------------
-- Tabla: gestiones_tipo
-- Prop�sito: Tipos de gesti�n que se pueden realizar
-- Ejemplos: Llamada, Email, Visita, SMS, etc.
-- ----------------------------------------------------------------
CREATE TABLE `gestiones_tipo` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ----------------------------------------------------------------
-- Tabla: gestiones_resultado -> 0 significa sin resultado
-- Prop�sito: Resultados posibles de una gesti�n
-- Ejemplos: Contactado, No contesta, Ocupado, Coordinado, Rechazado, etc. -> 0 significa sin resultado
-- ----------------------------------------------------------------
CREATE TABLE `gestiones_resultado` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- ================================================================
-- DATOS DE EJEMPLO PARA TESTING
-- ================================================================

-- Tipos de usuario b�sicos
INSERT INTO `users_tipos` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Operador', 'Agente telef�nico que realiza gestiones'),
(2, 'Supervisor', 'Supervisa el trabajo de los operadores'),
(3, 'Administrador', 'Acceso completo al sistema');

-- Estados de usuario
INSERT INTO `users_estados` (`id`, `nombre`) VALUES
(1, 'Activo'),
(2, 'Inactivo'),
(3, 'Suspendido');

-- Grupos de usuarios
INSERT INTO `users_grupos` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Ventas', 'Equipo de ventas telef�nicas'),
(2, 'Retenci�n', 'Equipo de retenci�n de clientes'),
(3, 'Cobranzas', 'Equipo de gesti�n de cobranzas');

-- Categor�as de usuarios
INSERT INTO `users_categorias` (`id`, `categoria`) VALUES
(1, 'Junior'),
(2, 'Senior'),
(3, 'Team Leader');

-- Estados de contactos
INSERT INTO `contactos_estado` (`id`, `nombre`) VALUES
(1, 'Prospecto'),
(2, 'Cliente'),
(3, 'Rechazado'),
(4, 'No contactar'),
(5, 'Seguimiento');

-- Estados de campa�as
INSERT INTO `campaigns_estados` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Activa', 'Campa�a en ejecuci�n'),
(2, 'Pausada', 'Campa�a temporalmente suspendida'),
(3, 'Finalizada', 'Campa�a completada'),
(4, 'Planificada', 'Campa�a programada para el futuro');

-- Tipos de gesti�n
INSERT INTO `gestiones_tipo` (`id`, `nombre`) VALUES
(1, 'Llamada'),
(2, 'Email'),
(3, 'SMS'),
(4, 'Visita'),
(5, 'WhatsApp');

-- Resultados de gesti�n m�s comunes
INSERT INTO `gestiones_resultado` (`id`, `nombre`) VALUES
(1, 'Coordinado'),
(2, 'Contactado'),
(3, 'No contesta'),
(4, 'Ocupado'),
(5, 'Fuera de servicio'),
(6, 'N�mero equivocado'),
(7, 'Rechazado'),
(8, 'Agendado'),
(9, 'No interesado'),
(10, 'Volver a llamar'),
(11, 'Pendiente'),
(12, 'Datos incorrectos'),
(13, 'Menor de edad'),
(14, 'Ya tiene el servicio'),
(15, 'Coordinar por mail'),
(16, 'Encuesta completada');

-- ================================================================
-- DATOS DUMMY PARA TESTING COMPLETO
-- ================================================================

-- Usuarios de ejemplo (5 operadores/supervisores)
INSERT INTO `users` (`id`, `id_tipo`, `id_estado`, `id_grupo`, `id_categoria`, `ci`, `nombre`, `apellido`, `usuario`, `password`, `id_tipo_escala`) VALUES
(1, 1, 1, 1, 1, 12345678, 'Juan', 'P�rez', 'jperez', 'hash123', 1),
(2, 1, 1, 1, 1, 23456789, 'Mar�a', 'Gonz�lez', 'mgonzalez', 'hash456', 1),
(3, 1, 1, 1, 2, 34567890, 'Carlos', 'Rodr�guez', 'crodriguez', 'hash789', 1),
(4, 2, 1, 1, 3, 45678901, 'Ana', 'Mart�nez', 'amartinez', 'hashabc', 2),
(5, 1, 1, 2, 2, 56789012, 'Pedro', 'L�pez', 'plopez', 'hashdef', 1);

-- Campa�as de ejemplo
INSERT INTO `campaigns` (`id`, `id_estado`, `codigo`, `nombre`, `descripcion`, `brokers`, `fc_inicio`, `fc_final`) VALUES
(1, 1, 'VENTA2025', 'Campa�a Ventas Q1 2025', 'Campa�a de ventas primer trimestre', '_1__2__3_', 20250101, 20250331),
(2, 1, 'RETEN2025', 'Retenci�n Clientes', 'Campa�a de retenci�n de clientes existentes', '_2__4__5_', 20250101, 20250630),
(3, 1, 'CROSS2025', 'Cross Selling', 'Venta cruzada de productos adicionales', '_1__3__5_', 20250201, 20250430),
(4, 2, 'COBRA2025', 'Cobranzas', 'Gesti�n de cobranzas morosas', '_4__5_', 20250101, 20251231),
(5, 1, 'ENCUES25', 'Encuestas Satisfacci�n', 'Encuestas de satisfacci�n post-venta', '_1__2__3__4_', 20250115, 20250315);

-- Tel�fonos de ejemplo (para usar en contactos)
INSERT INTO `telefonos` (`id`, `tipo`, `numero`) VALUES
(1, 1, 24001234),    -- Fijo
(2, 2, 98765432),    -- M�vil
(3, 1, 24005678),    -- Fijo
(4, 2, 99123456),    -- M�vil
(5, 1, 24009012),    -- Fijo
(6, 2, 97456789),    -- M�vil
(7, 1, 24003456),    -- Fijo
(8, 2, 96789012),    -- M�vil
(9, 1, 24007890),    -- Fijo
(10, 2, 95123456),   -- M�vil
(11, 2, 94567890),   -- M�vil adicional
(12, 2, 93456789),   -- M�vil adicional
(13, 1, 24002345),   -- Fijo adicional
(14, 1, 24006789),   -- Fijo adicional
(15, 2, 92345678),   -- M�vil adicional
(16, 2, 91234567),   -- M�vil adicional
(17, 1, 24004567),   -- Fijo adicional
(18, 1, 24008901),   -- Fijo adicional
(19, 2, 90123456),   -- M�vil adicional
(20, 2, 98901234);   -- M�vil adicional

-- Contactos de ejemplo (10 contactos)
INSERT INTO `contactos` (`id`, `id_estado`, `id_domicilio`, `id_ocupacion`, `id_estado_civil`, `ci`, `nombre1`, `nombre2`, `apellido1`, `apellido2`, `fc_nacimiento`, `sexo`, `zurdo`, `id_tel_fijo1`, `id_tel_fijo2`, `id_tel_movil1`, `id_tel_movil2`, `email`, `id_userinsert`, `id_fuente_dato`, `se_queda`, `timestamp`, `mascota`) VALUES
(1, 1, 1, 1, 1, 11111111, 'Roberto', 'Carlos', 'Silva', 'Mendoza', 19850315, 'M', 'N', 1, 13, 2, 11, 'roberto.silva@email.com', 1, 1, 0, 20250101120000, 1),
(2, 2, 2, 2, 2, 22222222, 'Laura', 'Isabel', 'Fern�ndez', 'Castro', 19920708, 'F', 'N', 3, 14, 4, 12, 'laura.fernandez@email.com', 2, 1, 1, 20250102130000, 0),
(3, 1, 3, 3, 1, 33333333, 'Miguel', '�ngel', 'Torres', 'Vega', 19880422, 'M', 'S', 5, 17, 6, 15, 'miguel.torres@email.com', 1, 2, 0, 20250103140000, 1),
(4, 1, 4, 1, 3, 44444444, 'Carmen', 'Rosa', 'Jim�nez', 'Morales', 19750912, 'F', 'N', 7, 18, 8, 16, 'carmen.jimenez@email.com', 3, 1, 0, 20250104150000, 0),
(5, 3, 5, 4, 1, 55555555, 'Andr�s', 'Felipe', 'Vargas', 'Ruiz', 19901203, 'M', 'N', 9, 0, 10, 19, 'andres.vargas@email.com', 2, 3, 1, 20250105160000, 1),
(6, 1, 6, 2, 2, 66666666, 'Patricia', 'Elena', 'Herrera', 'D�az', 19860825, 'F', 'N', 0, 1, 20, 2, 'patricia.herrera@email.com', 4, 1, 0, 20250106170000, 0),
(7, 2, 7, 5, 1, 77777777, 'Francisco', 'Javier', 'Ram�rez', 'Cruz', 19820617, 'M', 'S', 3, 5, 4, 6, 'francisco.ramirez@email.com', 1, 2, 1, 20250107180000, 1),
(8, 1, 8, 1, 4, 88888888, 'Beatriz', 'Alejandra', 'Guerrero', 'Pe�a', 19940210, 'F', 'N', 7, 9, 8, 10, 'beatriz.guerrero@email.com', 5, 1, 0, 20250108190000, 0),
(9, 1, 9, 3, 1, 99999999, 'Jorge', 'Luis', 'Mendoza', 'Flores', 19870530, 'M', 'N', 13, 17, 11, 15, 'jorge.mendoza@email.com', 3, 2, 0, 20250109200000, 1),
(10, 5, 10, 2, 2, 10101010, 'Valentina', 'Sof�a', 'Ortega', 'Restrepo', 19910914, 'F', 'N', 14, 18, 12, 16, 'valentina.ortega@email.com', 2, 1, 1, 20250110210000, 0);

-- Gestiones de ejemplo (100 gestiones distribuidas entre contactos, campa�as y operadores)
INSERT INTO `gestiones` (`id`, `id_tipo`, `id_campaign`, `id_broker`, `id_contacto`, `id_resultado`, `notas`, `timestamp`, `id_tel_fijo1`) VALUES
-- Gestiones para contacto 1
(1, 1, 1, 1, 1, 3, 'Primera llamada, no contesta', 20250115080000, 1),
(2, 1, 1, 1, 1, 2, 'Contactado, muestra inter�s', 20250116090000, 1),
(3, 1, 1, 1, 1, 1, 'Coordinada visita para el jueves', 20250117100000, 1),
(4, 1, 1, 2, 1, 8, 'Reagendado para la pr�xima semana', 20250118110000, 2),
(5, 1, 1, 2, 1, 1, 'Venta cerrada exitosamente', 20250119120000, 2),

-- Gestiones para contacto 2
(6, 1, 2, 3, 2, 2, 'Cliente actual, consulta sobre renovaci�n', 20250115130000, 3),
(7, 1, 2, 3, 2, 1, 'Acepta renovaci�n, coordinado pago', 20250116140000, 3),
(8, 1, 2, 4, 2, 11, 'Pendiente documentaci�n', 20250117150000, 4),
(9, 1, 2, 4, 2, 1, 'Documentaci�n completa, proceso finalizado', 20250118160000, 4),

-- Gestiones para contacto 3
(10, 1, 3, 5, 3, 4, 'L�nea ocupada', 20250115170000, 5),
(11, 1, 3, 5, 3, 3, 'No contesta segunda llamada', 20250116180000, 5),
(12, 1, 3, 1, 3, 2, 'Contactado, interesado en producto', 20250117190000, 6),
(13, 1, 3, 1, 3, 8, 'Agendado para presentaci�n', 20250118200000, 6),
(14, 1, 3, 2, 3, 1, 'Presentaci�n realizada, coordinado', 20250119210000, 6),

-- Gestiones para contacto 4
(15, 1, 1, 3, 4, 7, 'No est� interesada en el momento', 20250115220000, 7),
(16, 1, 1, 3, 4, 10, 'Solicita llamar en 2 semanas', 20250130080000, 7),
(17, 1, 1, 4, 4, 2, 'Segunda oportunidad, muestra inter�s', 20250201090000, 8),
(18, 1, 1, 4, 4, 1, 'Acepta propuesta, coordinado', 20250202100000, 8),

-- Gestiones para contacto 5
(19, 1, 4, 5, 5, 9, 'Cliente rechaza gesti�n de cobranza', 20250115110000, 9),
(20, 1, 4, 5, 5, 12, 'Datos de contacto incorrectos', 20250116120000, 10),
(21, 1, 4, 1, 5, 2, 'Actualizaci�n de datos, contactado', 20250117130000, 10),
(22, 1, 4, 1, 5, 11, 'Pendiente regularizar situaci�n', 20250118140000, 10),

-- Gestiones para contacto 6
(23, 1, 5, 2, 6, 16, 'Encuesta de satisfacci�n completada', 20250115150000, 1),
(24, 1, 1, 2, 6, 2, 'Cross selling, consult� otros productos', 20250116160000, 20),
(25, 1, 1, 3, 6, 8, 'Interesada, agendada nueva llamada', 20250117170000, 20),
(26, 1, 1, 3, 6, 1, 'Adquiere producto adicional', 20250118180000, 20),

-- Gestiones para contacto 7
(27, 1, 2, 4, 7, 2, 'Cliente fidelizado, consulta beneficios', 20250115190000, 3),
(28, 1, 2, 4, 7, 1, 'Acepta upgrade del servicio', 20250116200000, 3),
(29, 1, 2, 5, 7, 11, 'Pendiente activaci�n t�cnica', 20250117210000, 4),
(30, 1, 2, 5, 7, 1, 'Servicio activado correctamente', 20250118220000, 4),

-- Gestiones para contacto 8
(31, 1, 3, 1, 8, 13, 'Menor de edad, no puede contratar', 20250115230000, 7),
(32, 1, 3, 1, 8, 2, 'Habl� con tutor, autoriza gesti�n', 20250120080000, 8),
(33, 1, 3, 2, 8, 15, 'Coordinaci�n v�a email con tutor', 20250121090000, 8),
(34, 1, 3, 2, 8, 1, 'Contrato firmado por tutor', 20250122100000, 8),

-- Gestiones para contacto 9
(35, 1, 1, 3, 9, 6, 'N�mero equivocado', 20250115110000, 13),
(36, 1, 1, 3, 9, 2, 'N�mero correcto, contactado', 20250116120000, 11),
(37, 1, 1, 4, 9, 14, 'Ya tiene servicio similar con competencia', 20250117130000, 11),
(38, 1, 1, 4, 9, 10, 'Solicita llamar cuando venza contrato', 20250118140000, 11),

-- Gestiones para contacto 10
(39, 1, 5, 5, 10, 16, 'Encuesta completada, muy satisfecha', 20250115150000, 14),
(40, 1, 2, 5, 10, 2, 'Consulta sobre nuevos servicios', 20250116160000, 12),
(41, 1, 2, 1, 10, 1, 'Contrata servicio adicional', 20250117170000, 12),

-- Gestiones adicionales distribuidas aleatoriamente
(42, 1, 1, 1, 2, 3, 'No contesta en horario laboral', 20250119080000, 3),
(43, 1, 2, 2, 3, 4, 'L�nea ocupada durante la llamada', 20250119090000, 5),
(44, 1, 3, 3, 4, 5, 'Tel�fono fuera de servicio', 20250119100000, 7),
(45, 1, 4, 4, 5, 2, 'Contactado para seguimiento cobranza', 20250119110000, 9),
(46, 1, 5, 5, 6, 16, 'Segunda encuesta completada', 20250119120000, 1),
(47, 1, 1, 1, 7, 3, 'No atiende llamada matutina', 20250119130000, 3),
(48, 1, 2, 2, 8, 2, 'Contactada para retenci�n', 20250119140000, 7),
(49, 1, 3, 3, 9, 6, 'N�mero incorrecto en base datos', 20250119150000, 13),
(50, 1, 4, 4, 10, 11, 'Pendiente actualizaci�n datos', 20250119160000, 14),

(51, 1, 5, 5, 1, 2, 'Follow up encuesta anterior', 20250120080000, 1),
(52, 1, 1, 1, 3, 10, 'Reagendar para mejor horario', 20250120090000, 5),
(53, 1, 2, 2, 5, 7, 'Cliente rechaza propuesta', 20250120100000, 9),
(54, 1, 3, 3, 7, 2, 'Contactado para cross selling', 20250120110000, 3),
(55, 1, 4, 4, 9, 12, 'Actualizar informaci�n de contacto', 20250120120000, 11),
(56, 1, 5, 5, 2, 1, 'Encuesta y venta cruzada exitosa', 20250120130000, 3),
(57, 1, 1, 1, 4, 8, 'Agendar para pr�xima semana', 20250120140000, 7),
(58, 1, 2, 2, 6, 2, 'Consulta sobre renovaci�n', 20250120150000, 20),
(59, 1, 3, 3, 8, 11, 'Pendiente documentaci�n legal', 20250120160000, 7),
(60, 1, 4, 4, 10, 1, 'Regularizaci�n de cuenta exitosa', 20250120170000, 14),

(61, 1, 1, 2, 1, 3, 'Tercer intento, no contesta', 20250121080000, 1),
(62, 1, 2, 3, 2, 2, 'Consulta adicional sobre servicios', 20250121090000, 3),
(63, 1, 3, 4, 3, 1, 'Cierre exitoso de venta', 20250121100000, 5),
(64, 1, 4, 5, 4, 9, 'No interesada en momento actual', 20250121110000, 7),
(65, 1, 5, 1, 5, 16, 'Encuesta post-regularizaci�n', 20250121120000, 9),
(66, 1, 1, 2, 6, 2, 'Seguimiento producto adicional', 20250121130000, 20),
(67, 1, 2, 3, 7, 1, 'Upgrade confirmado y activado', 20250121140000, 3),
(68, 1, 3, 4, 8, 2, 'Contacto con tutor confirmado', 20250121150000, 7),
(69, 1, 4, 5, 9, 3, 'No contesta en nuevo n�mero', 20250121160000, 11),
(70, 1, 5, 1, 10, 2, 'Seguimiento satisfacci�n cliente', 20250121170000, 14),

(71, 1, 1, 3, 1, 4, 'Ocupado durante horario comercial', 20250122080000, 1),
(72, 1, 2, 4, 2, 1, 'Renovaci�n procesada exitosamente', 20250122090000, 3),
(73, 1, 3, 5, 3, 11, 'Pendiente activaci�n t�cnica', 20250122100000, 5),
(74, 1, 4, 1, 4, 2, 'Recontacto despu�s de rechazo', 20250122110000, 7),
(75, 1, 5, 2, 5, 2, 'Nueva encuesta de seguimiento', 20250122120000, 9),
(76, 1, 1, 3, 6, 8, 'Reagendado para presentaci�n', 20250122130000, 20),
(77, 1, 2, 4, 7, 2, 'Cliente consulta nuevos beneficios', 20250122140000, 3),
(78, 1, 3, 5, 8, 1, 'Contrato menor edad procesado', 20250122150000, 7),
(79, 1, 4, 1, 9, 2, 'Contactado en n�mero actualizado', 20250122160000, 11),
(80, 1, 5, 2, 10, 16, 'Encuesta satisfacci�n completada', 20250122170000, 14),

(81, 1, 1, 4, 1, 2, 'Contactado para nueva oferta', 20250123080000, 1),
(82, 1, 2, 5, 2, 11, 'Pendiente firma documentos', 20250123090000, 3),
(83, 1, 3, 1, 3, 1, 'Activaci�n t�cnica completada', 20250123100000, 5),
(84, 1, 4, 2, 4, 10, 'Volver a llamar pr�ximo mes', 20250123110000, 7),
(85, 1, 5, 3, 5, 2, 'Encuesta post regularizaci�n', 20250123120000, 9),
(86, 1, 1, 4, 6, 1, 'Producto adicional confirmado', 20250123130000, 20),
(87, 1, 2, 5, 7, 2, 'Seguimiento upgrade servicio', 20250123140000, 3),
(88, 1, 3, 1, 8, 11, 'Pendiente activaci�n tutor', 20250123150000, 7),
(89, 1, 4, 2, 9, 14, 'Competencia vence en 6 meses', 20250123160000, 11),
(90, 1, 5, 3, 10, 1, 'Servicio adicional activado', 20250123170000, 14),

(91, 1, 1, 5, 1, 3, 'No contesta en horario tarde', 20250124080000, 1),
(92, 1, 2, 1, 2, 2, 'Cliente muy satisfecho', 20250124090000, 3),
(93, 1, 3, 2, 3, 1, 'Proceso completado exitosamente', 20250124100000, 5),
(94, 1, 4, 3, 4, 8, 'Reagendado para fin de mes', 20250124110000, 7),
(95, 1, 5, 4, 5, 16, '�ltima encuesta del proceso', 20250124120000, 9),
(96, 1, 1, 5, 6, 2, 'Seguimiento final producto', 20250124130000, 20),
(97, 1, 2, 1, 7, 1, 'Fidelizaci�n completada', 20250124140000, 3),
(98, 1, 3, 2, 8, 2, 'Confirmaci�n final tutor', 20250124150000, 7),
(99, 1, 4, 3, 9, 2, 'Datos actualizados correctamente', 20250124160000, 11),
(100, 1, 5, 4, 10, 1, 'Proceso integral completado', 20250124170000, 14);

-- ================================================================
-- RELACIONES Y CLAVES FOR�NEAS (DOCUMENTACI�N)
-- ================================================================

/*
IMPORTANTE: Las siguientes relaciones existen l�gicamente pero NO est�n 
implementadas como restricciones FK en la base de datos original por 
razones de rendimiento y flexibilidad operativa.

RELACIONES PRINCIPALES:

1. users -> users_tipos (users.id_tipo = users_tipos.id)
2. users -> users_estados (users.id_estado = users_estados.id)
3. users -> users_grupos (users.id_grupo = users_grupos.id)
4. users -> users_categorias (users.id_categoria = users_categorias.id)

5. contactos -> contactos_estado (contactos.id_estado = contactos_estado.id)
6. contactos -> telefonos (contactos.id_tel_fijo1 = telefonos.id)
7. contactos -> telefonos (contactos.id_tel_fijo2 = telefonos.id)
8. contactos -> telefonos (contactos.id_tel_movil1 = telefonos.id)
9. contactos -> telefonos (contactos.id_tel_movil2 = telefonos.id)
10. contactos -> users (contactos.id_userinsert = users.id)

11. campaigns -> campaigns_estados (campaigns.id_estado = campaigns_estados.id)

12. gestiones -> gestiones_tipo (gestiones.id_tipo = gestiones_tipo.id)
13. gestiones -> campaigns (gestiones.id_campaign = campaigns.id)
14. gestiones -> users (gestiones.id_broker = users.id)
15. gestiones -> contactos (gestiones.id_contacto = contactos.id)
16. gestiones -> gestiones_resultado (gestiones.id_resultado = gestiones_resultado.id) -> 0 significa sin resultado

FLUJO DE TRABAJO T�PICO:
1. Se crea una campa�a (campaigns)
2. Se asignan operadores (users) a la campa�a
3. Se importan o crean contactos (contactos)
4. Los operadores realizan gestiones (gestiones) sobre los contactos
5. Cada gesti�n tiene un resultado espec�fico que determina el pr�ximo paso

CONSULTAS T�PICAS:
- Listar gestiones de un operador en una fecha espec�fica
- Obtener todos los contactos de una campa�a con resultado "No contesta"
- Calcular estad�sticas de rendimiento por operador/campa�a
- Buscar contactos por n�mero de tel�fono o documento
*/

-- ================================================================
-- �NDICES RECOMENDADOS PARA OPTIMIZACI�N
-- ================================================================

/*
Los siguientes �ndices est�n presentes en la estructura original y son 
cr�ticos para el rendimiento:

1. gestiones.timestamp - Para consultas por fecha/per�odo
2. gestiones.id_campaign - Para filtrar por campa�a
3. gestiones.id_broker - Para consultas por operador
4. gestiones.id_contacto - Para historial de un contacto
5. contactos.id_tel_fijo1, id_tel_movil1 - Para b�squedas por tel�fono
6. telefonos.numero - Para b�squedas r�pidas de n�meros
7. campaigns.codigo - Para acceso directo por c�digo de campa�a

CONSIDERACIONES DE RENDIMIENTO:
- El campo timestamp usa formato YYYYMMDDhhiiss como CHAR para rapidez
- Los IDs de tel�fono permiten normalizaci�n sin p�rdida de performance
- Las tablas de resultados son peque�as y se cachean en memoria
*/
