DROP DATABASE IF EXISTS cerradura;
CREATE DATABASE cerradura CHARACTER SET utf8 COLLATE utf8_general_ci;
USE cerradura;

-- Estructura de tabla para la tabla alumnos
CREATE TABLE alumnos (
  id INT NOT NULL AUTO_INCREMENT,
  matricula varchar(64) ,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  unidad varchar(64) NOT NULL,
  division varchar(64) NOT NULL,
  planEstudio varchar(64) NOT NULL,
  edad int NOT NULL DEFAULT '0',
  email varchar(64) NOT NULL,
  telefono varchar(64) NOT NULL,
  RFID varchar(64) NOT NULL,
 
  PRIMARY KEY (id),
  UNIQUE (matricula)
  
) ENGINE=InnoDB ;

-- Estructura de tabla para la tabla LaboratoriosYAulas
CREATE TABLE laboratoriosyaulas (
  id INT NOT NULL AUTO_INCREMENT,
  nombre varchar(64) NOT NULL,
  aforoPermitido varchar(64) NOT NULL,
  aforoActual varchar(64) NOT NULL,
  estadoPuerta varchar(64) NOT NULL,
  LecturaTemperatura varchar(64) NOT NULL,
  notificaciones varchar(64) NOT NULL,
  profesorAdentro varchar(64) NOT NULL,
  noEmpleado varchar(64) NOT NULL,
  nombrePro varchar(64) NOT NULL,
  url varchar(128) NOT NULL,
  
  PRIMARY KEY (id)
) ENGINE=InnoDB ;


-- Estructura de tabla para la tabla profesoresYPersonal
CREATE TABLE profesoresypersonal (
  id INT NOT NULL AUTO_INCREMENT,
  noEmpleado varchar(64) ,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  unidad varchar(64) ,
  division varchar(64) ,
  edad int NOT NULL DEFAULT '0',
  email varchar(64) NOT NULL,
  telefono varchar(64) NOT NULL,
  clave varchar(64) NOT NULL,
  huella varchar(64) NOT NULL,
  
  PRIMARY KEY (id),
  UNIQUE (noEmpleado)
) ENGINE=InnoDB ;


-- Estructura de tabla para la tabla registroEntradaAlumnos
CREATE TABLE registroentradaalumnos (
  id INT NOT NULL AUTO_INCREMENT,
  RFID varchar(64) NOT NULL,
  matricula varchar(64) NOT NULL,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  temperatura varchar(64) ,
  area varchar(128)  NOT NULL,
  fecha timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  
  PRIMARY KEY (id),
  UNIQUE (RFID)
) ENGINE=InnoDB ;


-- Estructura de tabla para la tabla registroEntradaAlumnosHistorial
CREATE TABLE registroentradaalumnoshistorial (
  id INT NOT NULL AUTO_INCREMENT,
  RFID varchar(64) NOT NULL,
  matricula varchar(64) NOT NULL,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  temperatura varchar(64) NOT NULL,
  area varchar(128) NOT NULL,
  fecha timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  
  PRIMARY KEY (id)
) ENGINE=InnoDB ;


-- Estructura de tabla para la tabla registroEntradaProfesoresYPersonal
CREATE TABLE registroentradaprofesoresypersonal (
  id INT NOT NULL AUTO_INCREMENT,
  clave varchar(64) NOT NULL,
  huella varchar(64) NOT NULL,
  noEmpleado varchar(64) NOT NULL,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  temperatura varchar(64) NOT NULL,
  area varchar(128) NOT NULL,
  fecha timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  
  PRIMARY KEY (id)
) ENGINE=InnoDB ;


-- Estructura de tabla para la tabla registroEntradaProfesoresYPersonalHistorial
CREATE TABLE registroentradaprofesoresypersonalhistorial (
  id INT NOT NULL AUTO_INCREMENT,
  clave varchar(64) NOT NULL,
  huella varchar(64) NOT NULL,
  noEmpleado varchar(64) NOT NULL,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  temperatura varchar(64) NOT NULL,
  area varchar(128) NOT NULL,
  fecha timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  
   PRIMARY KEY (id)
) ENGINE=InnoDB ;


-- Estructura de tabla para la tabla registroSalidaAlumnos
CREATE TABLE registrosalidaalumnos (
  id INT NOT NULL AUTO_INCREMENT,
  RFID varchar(64) NOT NULL,
  matricula varchar(64) NOT NULL,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  area varchar(128) NOT NULL,
  fecha timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  
   PRIMARY KEY (id)
) ENGINE=InnoDB ;


-- Estructura de tabla para la tabla registroSalidaAlumnosHistorial
CREATE TABLE registrosalidaalumnoshistorial (
  id INT NOT NULL AUTO_INCREMENT,
  RFID varchar(64) NOT NULL,
  matricula varchar(64) NOT NULL,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  area varchar(128) NOT NULL,
  fecha timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  
   PRIMARY KEY (id)
) ENGINE=InnoDB ;


-- Estructura de tabla para la tabla registroSalidaProfesoresYPersonalHistorial
CREATE TABLE registrosalidaprofesoresypersonalhistorial (
  id INT NOT NULL AUTO_INCREMENT,
  clave varchar(64) NOT NULL,
  huella varchar(64) NOT NULL,
  noEmpleado varchar(64) NOT NULL,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  area varchar(128) NOT NULL,
  fecha timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  
   PRIMARY KEY (id)
) ENGINE=InnoDB ;


-- Estructura de tabla para la tabla temperaturaAltaAlumnos
CREATE TABLE temperaturaaltaalumnos (
  id INT NOT NULL AUTO_INCREMENT,
  RFID varchar(64) NOT NULL,
  matricula varchar(64) NOT NULL,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  temperatura varchar(64) NOT NULL,
  area varchar(128) NOT NULL,
  fecha timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  
   PRIMARY KEY (id)
) ENGINE=InnoDB ;


-- Estructura de tabla para la tabla temperaturaAltaProfesoresYPersonal
CREATE TABLE temperaturaaltaprofesoresypersonal (
  id INT NOT NULL AUTO_INCREMENT,
  clave varchar(64) NOT NULL,
  huella varchar(64) NOT NULL,
  noEmpleado varchar(64) NOT NULL,
  nombre varchar(64) NOT NULL,
  apellidos varchar(64) NOT NULL,
  temperatura varchar(64) NOT NULL,
  area varchar(128) NOT NULL,
  fecha timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  
   PRIMARY KEY (id)
) ENGINE=InnoDB ;

CREATE TABLE users (
   id INT NOT NULL AUTO_INCREMENT,
   username varchar(64) NOT NULL,
   password VARCHAR(64) NOT NULL,
   fullname varchar(64) NOT NULL,
   
   PRIMARY KEY (id)
) ENGINE=InnoDB;


