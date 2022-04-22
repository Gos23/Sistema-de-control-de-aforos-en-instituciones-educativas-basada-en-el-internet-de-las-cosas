-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 21-04-2022 a las 22:59:35
-- Versión del servidor: 8.0.28-0ubuntu0.20.04.3
-- Versión de PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cerradura`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alumnos`
--

CREATE TABLE `alumnos` (
  `id` int NOT NULL,
  `matricula` varchar(64) DEFAULT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `unidad` varchar(64) NOT NULL,
  `division` varchar(64) NOT NULL,
  `planEstudio` varchar(64) NOT NULL,
  `edad` int NOT NULL DEFAULT '0',
  `email` varchar(64) NOT NULL,
  `telefono` varchar(64) NOT NULL,
  `RFID` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `alumnos`
--

INSERT INTO `alumnos` (`id`, `matricula`, `nombre`, `apellidos`, `unidad`, `division`, `planEstudio`, `edad`, `email`, `telefono`, `RFID`) VALUES
(1, '2172002785', 'Giovanni', 'Olmos Salmones', 'Azcapotzalco', 'Ciencias Básicas e Ingeniería', 'Ingeniería en Computación', 23, 'al2172002785@azc.uam.mx', '5531376147', '2357885037'),
(2, '2172000781', 'Gabriel', 'Hurtado Aviles', 'Azcapotzalco', 'Ciencias Básicas e Ingeniería', 'Ingeniería en Computación', 23, 'al2172000781@azc.uam.mx', '5537615498', '3284057353'),
(3, '2173074687', 'Irving', 'Martínez Fernández', 'Azcapotzalco', 'Ciencias Básicas e Ingeniería', 'Ingeniería en Computación', 23, 'al2173074687@azc.uam.mx', '5531346254', '2201507601');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `laboratoriosyaulas`
--

CREATE TABLE `laboratoriosyaulas` (
  `id` int NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `aforoPermitido` varchar(64) NOT NULL,
  `aforoActual` varchar(64) NOT NULL,
  `estadoPuerta` varchar(64) NOT NULL,
  `LecturaTemperatura` varchar(64) NOT NULL,
  `notificaciones` varchar(64) NOT NULL,
  `profesorAdentro` varchar(64) NOT NULL,
  `noEmpleado` varchar(64) NOT NULL,
  `nombrePro` varchar(64) NOT NULL,
  `url` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `laboratoriosyaulas`
--

INSERT INTO `laboratoriosyaulas` (`id`, `nombre`, `aforoPermitido`, `aforoActual`, `estadoPuerta`, `LecturaTemperatura`, `notificaciones`, `profesorAdentro`, `noEmpleado`, `nombrePro`, `url`) VALUES
(1, 'Laboratorio de Sistemas Digitales', '5', '1', 'cerrado', 'false', 'true', 'true', '250515', 'Sara Aguilar Ortega', 'http://192.168.100.203:1880/ui/#!/1'),
(2, 'Laboratorio de Diseño Logico', '30', '0', 'cerrado', 'false', 'true', 'false', ' ', ' ', 'http://192.168.100.203:1880/ui/#!/0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesoresypersonal`
--

CREATE TABLE `profesoresypersonal` (
  `id` int NOT NULL,
  `noEmpleado` varchar(64) DEFAULT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `unidad` varchar(64) DEFAULT NULL,
  `division` varchar(64) DEFAULT NULL,
  `edad` int NOT NULL DEFAULT '0',
  `email` varchar(64) NOT NULL,
  `telefono` varchar(64) NOT NULL,
  `clave` varchar(64) NOT NULL,
  `huella` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `profesoresypersonal`
--

INSERT INTO `profesoresypersonal` (`id`, `noEmpleado`, `nombre`, `apellidos`, `unidad`, `division`, `edad`, `email`, `telefono`, `clave`, `huella`) VALUES
(1, '190315', 'Jose', 'Martinez Vargas', 'Azcapotzalco', 'Ciencias Básicas e Ingeniería', 50, 'marva@azc.com.mx', '5534312654', '2172002785', '2'),
(2, '250515', 'Sara', 'Aguilar Ortega', 'Azcapotzalco', 'Ciencias Básicas e Ingeniería', 45, '250515@azc.uam.mx', '5531346254', '2172002786', '3');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registroentradaalumnos`
--

CREATE TABLE `registroentradaalumnos` (
  `id` int NOT NULL,
  `RFID` varchar(64) NOT NULL,
  `matricula` varchar(64) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `temperatura` varchar(64) DEFAULT NULL,
  `area` varchar(128) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registroentradaalumnoshistorial`
--

CREATE TABLE `registroentradaalumnoshistorial` (
  `id` int NOT NULL,
  `RFID` varchar(64) NOT NULL,
  `matricula` varchar(64) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `temperatura` varchar(64) NOT NULL,
  `area` varchar(128) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `registroentradaalumnoshistorial`
--

INSERT INTO `registroentradaalumnoshistorial` (`id`, `RFID`, `matricula`, `nombre`, `apellidos`, `temperatura`, `area`, `fecha`) VALUES
(1, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '34.29999542', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:03:44'),
(2, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '35.69998932', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:07:32'),
(3, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '35.41999054', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:25:45'),
(4, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '34.54001617', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:40:48'),
(5, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '35.38001251', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:17:44'),
(6, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '35.62000275', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:23:42'),
(7, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '35.41999054', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:24:01'),
(8, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '35.79999542', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:24:11'),
(9, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '35.90000153', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:24:14'),
(10, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '36.01999664', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:24:16'),
(11, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '36.01999664', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:24:18'),
(12, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '34.68000031', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:27:22'),
(13, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '34.25998688', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:27:32'),
(14, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '34.41999054', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:27:34'),
(15, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '34.54001617', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:27:36'),
(16, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '33.63999176', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:30:46'),
(17, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '35.06000519', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:32:53'),
(18, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:32:58'),
(19, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:36:32'),
(20, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:36:40'),
(21, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:59:34'),
(22, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:59:38'),
(23, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-11 23:04:42'),
(24, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:27:32'),
(25, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:27:41'),
(26, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:30:18'),
(27, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Diseño Logico', '2022-04-12 02:26:50'),
(28, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Diseño Logico', '2022-04-12 02:26:57'),
(29, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Diseño Logico', '2022-04-12 02:31:56'),
(30, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Diseño Logico', '2022-04-12 02:32:24'),
(31, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 17:50:28'),
(32, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 17:50:57'),
(33, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:40:50'),
(34, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:42:02'),
(35, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:50:41'),
(36, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:27:41'),
(37, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:27:53'),
(38, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:27:57'),
(39, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:28:04'),
(40, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '37.01999664', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:32:03'),
(41, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '35.90000153', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:40:04'),
(42, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:41:52'),
(43, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:41:55'),
(44, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:31:02'),
(45, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:31:06'),
(46, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:31:37'),
(47, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:31:58'),
(48, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:35:47'),
(49, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:38:23'),
(50, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '35.73999786', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:56:46'),
(51, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '35.51999664', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:56:55'),
(52, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:58:11'),
(53, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:58:14'),
(54, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:02:41'),
(55, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:02:54'),
(56, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:10:28'),
(57, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:15:07'),
(58, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:15:48'),
(59, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '36.75998688', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:23:05'),
(60, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:23:42'),
(61, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '37.04001617', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:26:48'),
(62, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '35.50000763', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:29:32'),
(63, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:29:36'),
(64, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:31:11'),
(65, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:34:18'),
(66, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:35:23'),
(67, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:36:10'),
(68, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:36:31'),
(69, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:54:48'),
(70, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:55:00'),
(71, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:55:10'),
(72, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:55:10'),
(73, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:56:01'),
(74, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Diseño Logico', '2022-04-20 02:22:23'),
(75, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 02:22:35'),
(76, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 03:26:13'),
(77, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', '0', 'Laboratorio de Diseño Logico', '2022-04-20 03:26:13'),
(78, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-21 23:23:20'),
(79, '2201507601', '2173074687', 'Irving', 'Martínez Fernández', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:16:46'),
(80, '3284057353', '2172000781', 'Gabriel', 'Hurtado Aviles', '35.95999908', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:17:31'),
(81, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:18:46');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registroentradaprofesoresypersonal`
--

CREATE TABLE `registroentradaprofesoresypersonal` (
  `id` int NOT NULL,
  `clave` varchar(64) NOT NULL,
  `huella` varchar(64) NOT NULL,
  `noEmpleado` varchar(64) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `temperatura` varchar(64) NOT NULL,
  `area` varchar(128) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `registroentradaprofesoresypersonal`
--

INSERT INTO `registroentradaprofesoresypersonal` (`id`, `clave`, `huella`, `noEmpleado`, `nombre`, `apellidos`, `temperatura`, `area`, `fecha`) VALUES
(68, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:35:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registroentradaprofesoresypersonalhistorial`
--

CREATE TABLE `registroentradaprofesoresypersonalhistorial` (
  `id` int NOT NULL,
  `clave` varchar(64) NOT NULL,
  `huella` varchar(64) NOT NULL,
  `noEmpleado` varchar(64) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `temperatura` varchar(64) NOT NULL,
  `area` varchar(128) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `registroentradaprofesoresypersonalhistorial`
--

INSERT INTO `registroentradaprofesoresypersonalhistorial` (`id`, `clave`, `huella`, `noEmpleado`, `nombre`, `apellidos`, `temperatura`, `area`, `fecha`) VALUES
(1, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '36.00000763', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:03:24'),
(2, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:06:55'),
(3, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '35.29999542', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:25:26'),
(4, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '34.73999786', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:40:22'),
(5, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '34.91999054', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:17:26'),
(6, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '33.5799942', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:32:35'),
(7, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:36:25'),
(8, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:59:21'),
(9, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:27:22'),
(10, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:30:03'),
(11, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-12 02:22:01'),
(12, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-12 02:26:00'),
(13, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-12 02:39:04'),
(14, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-12 02:39:52'),
(15, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-12 02:45:47'),
(16, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-12 02:46:43'),
(17, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-12 02:48:24'),
(18, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 17:50:14'),
(19, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 18:50:00'),
(20, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:35:49'),
(21, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:35:52'),
(22, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:38:08'),
(23, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:40:34'),
(24, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:41:51'),
(25, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:42:52'),
(26, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:43:32'),
(27, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:44:29'),
(28, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-19 21:46:13'),
(29, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-19 21:46:27'),
(30, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-19 21:47:09'),
(31, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:50:32'),
(32, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:51:00'),
(33, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:27:30'),
(34, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '37.13999176', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:31:33'),
(35, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:42:44'),
(36, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:50:35'),
(37, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '37.0799942', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:51:31'),
(38, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:15:20'),
(39, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:30:53'),
(40, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '35.23999786', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:42:16'),
(41, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '35.51999664', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:51:31'),
(42, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '35.73999786', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:53:55'),
(43, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '35.82001495', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:56:20'),
(44, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '35.56000519', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:56:37'),
(45, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:57:52'),
(46, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '35.51999664', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:58:38'),
(47, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 00:03:57'),
(48, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:01:07'),
(49, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:09:59'),
(50, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:18:09'),
(51, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '36.84000397', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:22:09'),
(52, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:23:28'),
(53, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:37:58'),
(54, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Diseño Logico', '2022-04-20 01:54:37'),
(55, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:54:40'),
(56, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 02:21:18'),
(57, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Diseño Logico', '2022-04-20 02:21:20'),
(58, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Diseño Logico', '2022-04-20 03:25:59'),
(59, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-20 03:26:01'),
(60, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-21 22:58:56'),
(61, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:08:38'),
(62, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:10:36'),
(63, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:13:46'),
(64, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:15:54'),
(65, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:23:35'),
(66, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:24:26'),
(67, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:35:03'),
(68, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '0', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:35:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registrosalidaalumnos`
--

CREATE TABLE `registrosalidaalumnos` (
  `id` int NOT NULL,
  `RFID` varchar(64) NOT NULL,
  `matricula` varchar(64) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `area` varchar(128) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `registrosalidaalumnos`
--

INSERT INTO `registrosalidaalumnos` (`id`, `RFID`, `matricula`, `nombre`, `apellidos`, `area`, `fecha`) VALUES
(1, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:05:04'),
(2, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:09:51'),
(3, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:31:56'),
(4, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:15:02'),
(5, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:26:46'),
(6, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:30:34'),
(7, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:31:57'),
(8, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:32:01'),
(9, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:33:44'),
(10, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:33:47'),
(11, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:44:48'),
(12, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:44:52'),
(13, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 23:03:09'),
(14, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 23:05:15'),
(15, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 23:05:17'),
(16, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:29:38'),
(17, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:29:42'),
(18, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:30:41'),
(19, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Diseño Logico', '2022-04-12 02:31:27'),
(20, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Diseño Logico', '2022-04-12 02:31:34'),
(21, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Diseño Logico', '2022-04-12 02:37:27'),
(22, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Diseño Logico', '2022-04-12 02:37:30'),
(23, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 17:55:37'),
(24, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 17:55:40'),
(25, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:41:10'),
(26, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:42:30'),
(27, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:26:02'),
(28, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:27:46'),
(29, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:27:58'),
(30, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:30:20'),
(31, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:30:28'),
(32, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:40:24'),
(33, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:40:28'),
(34, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:42:25'),
(35, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:42:28'),
(36, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:31:32'),
(37, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:31:48'),
(38, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:31:59'),
(39, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:36:23'),
(40, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:38:32'),
(41, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:38:34'),
(42, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:57:38'),
(43, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:57:41'),
(44, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:58:22'),
(45, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:58:25'),
(46, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:10:18'),
(47, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:15:36'),
(48, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Diseño Logico', '2022-04-20 01:15:42'),
(49, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:16:06'),
(50, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:16:10'),
(51, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Diseño Logico', '2022-04-20 01:23:55'),
(52, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:25:05'),
(53, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:28:58'),
(54, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Diseño Logico', '2022-04-20 01:29:58'),
(55, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:30:45'),
(56, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:31:14'),
(57, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Diseño Logico', '2022-04-20 01:36:25'),
(58, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:36:31'),
(59, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:36:34'),
(60, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:55:03'),
(61, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Diseño Logico', '2022-04-20 01:55:03'),
(62, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:56:06'),
(63, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Diseño Logico', '2022-04-20 01:56:09'),
(64, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:56:10'),
(65, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 02:26:04'),
(66, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Diseño Logico', '2022-04-20 02:27:18'),
(67, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 03:26:39'),
(68, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Diseño Logico', '2022-04-20 03:26:39'),
(69, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-21 23:23:22'),
(70, '3284057353', '2172000781', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:19:24'),
(71, '2201507601', '2173074687', 'Irving', 'Martínez Fernández', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:19:28'),
(72, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:19:31');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registrosalidaalumnoshistorial`
--

CREATE TABLE `registrosalidaalumnoshistorial` (
  `id` int NOT NULL,
  `RFID` varchar(64) NOT NULL,
  `matricula` varchar(64) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `area` varchar(128) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `registrosalidaalumnoshistorial`
--

INSERT INTO `registrosalidaalumnoshistorial` (`id`, `RFID`, `matricula`, `nombre`, `apellidos`, `area`, `fecha`) VALUES
(1, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:05:04'),
(2, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:09:51'),
(3, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:31:56'),
(4, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:15:02'),
(5, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:26:46'),
(6, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:30:34'),
(7, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:31:57'),
(8, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:32:01'),
(9, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:33:44'),
(10, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:33:47'),
(11, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:44:48'),
(12, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:44:52'),
(13, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 23:03:09'),
(14, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-11 23:05:15'),
(15, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-11 23:05:17'),
(16, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:29:38'),
(17, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:29:42'),
(18, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:30:41'),
(19, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Diseño Logico', '2022-04-12 02:31:27'),
(20, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Diseño Logico', '2022-04-12 02:31:34'),
(21, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Diseño Logico', '2022-04-12 02:37:27'),
(22, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Diseño Logico', '2022-04-12 02:37:30'),
(23, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 17:55:37'),
(24, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 17:55:40'),
(25, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:41:10'),
(26, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:42:30'),
(27, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:26:02'),
(28, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:27:46'),
(29, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:27:58'),
(30, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:30:20'),
(31, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:30:28'),
(32, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:40:24'),
(33, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:40:28'),
(34, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:42:25'),
(35, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:42:28'),
(36, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:31:32'),
(37, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:31:48'),
(38, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:31:59'),
(39, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:36:23'),
(40, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:38:32'),
(41, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:38:34'),
(42, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:57:38'),
(43, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:57:41'),
(44, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:58:22'),
(45, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:58:25'),
(46, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:10:18'),
(47, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:15:36'),
(48, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Diseño Logico', '2022-04-20 01:15:42'),
(49, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:16:06'),
(50, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:16:10'),
(51, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Diseño Logico', '2022-04-20 01:23:55'),
(52, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:25:05'),
(53, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:28:58'),
(54, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Diseño Logico', '2022-04-20 01:29:58'),
(55, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:30:45'),
(56, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:31:14'),
(57, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Diseño Logico', '2022-04-20 01:36:25'),
(58, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:36:31'),
(59, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:36:34'),
(60, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:55:03'),
(61, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Diseño Logico', '2022-04-20 01:55:03'),
(62, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:56:06'),
(63, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Diseño Logico', '2022-04-20 01:56:09'),
(64, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:56:10'),
(65, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 02:26:04'),
(66, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Diseño Logico', '2022-04-20 02:27:18'),
(67, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-20 03:26:39'),
(68, '2201507601', '2172002787', 'Amaury', 'Tobar Basurto', 'Laboratorio de Diseño Logico', '2022-04-20 03:26:39'),
(69, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-21 23:23:22'),
(70, '3284057353', '2172000781', 'Gabriel', 'Hurtado Aviles', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:19:24'),
(71, '2201507601', '2173074687', 'Irving', 'Martínez Fernández', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:19:28'),
(72, '2357885037', '2172002785', 'Giovanni', 'Olmos Salmones', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:19:31');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registrosalidaprofesoresypersonalhistorial`
--

CREATE TABLE `registrosalidaprofesoresypersonalhistorial` (
  `id` int NOT NULL,
  `clave` varchar(64) NOT NULL,
  `huella` varchar(64) NOT NULL,
  `noEmpleado` varchar(64) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `area` varchar(128) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `registrosalidaprofesoresypersonalhistorial`
--

INSERT INTO `registrosalidaprofesoresypersonalhistorial` (`id`, `clave`, `huella`, `noEmpleado`, `nombre`, `apellidos`, `area`, `fecha`) VALUES
(1, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:05:30'),
(2, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:09:59'),
(3, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-11 18:32:04'),
(4, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:15:11'),
(5, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:32:09'),
(6, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-11 19:33:54'),
(7, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-11 22:44:56'),
(8, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-11 23:05:22'),
(9, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:29:51'),
(10, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-12 01:30:47'),
(11, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Diseño Logico', '2022-04-12 02:24:22'),
(12, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Diseño Logico', '2022-04-12 02:37:34'),
(13, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-12 02:39:24'),
(14, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Diseño Logico', '2022-04-12 02:44:22'),
(15, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Diseño Logico', '2022-04-12 02:46:38'),
(16, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Diseño Logico', '2022-04-12 02:47:22'),
(17, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Diseño Logico', '2022-04-12 02:48:30'),
(18, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 17:55:43'),
(19, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 19:07:08'),
(20, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:36:25'),
(21, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:39:57'),
(22, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:41:16'),
(23, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:42:40'),
(24, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:43:02'),
(25, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:44:12'),
(26, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Diseño Logico', '2022-04-19 21:46:20'),
(27, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Diseño Logico', '2022-04-19 21:46:35'),
(28, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:47:34'),
(29, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 21:50:54'),
(30, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:26:05'),
(31, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:30:36'),
(32, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:42:31'),
(33, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:43:11'),
(34, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:51:02'),
(35, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:51:44'),
(36, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:16:11'),
(37, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:38:38'),
(38, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:42:59'),
(39, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:53:42'),
(40, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:56:27'),
(41, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:57:44'),
(42, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:58:28'),
(43, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:58:46'),
(44, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-20 00:04:14'),
(45, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Diseño Logico', '2022-04-20 01:16:17'),
(46, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:18:46'),
(47, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Diseño Logico', '2022-04-20 01:18:54'),
(48, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:37:51'),
(49, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Diseño Logico', '2022-04-20 01:37:53'),
(50, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Diseño Logico', '2022-04-20 01:38:15'),
(51, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Diseño Logico', '2022-04-20 01:56:18'),
(52, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:56:19'),
(53, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-20 02:26:19'),
(54, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Diseño Logico', '2022-04-20 02:27:32'),
(55, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-20 03:26:47'),
(56, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Diseño Logico', '2022-04-20 03:26:49'),
(57, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-21 23:23:31'),
(58, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:10:21'),
(59, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:12:26'),
(60, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:14:11'),
(61, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:19:42'),
(62, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:24:19'),
(63, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:25:56'),
(64, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', 'Laboratorio de Sistemas Digitales', '2022-04-22 00:35:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int UNSIGNED NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `sessions`
--

INSERT INTO `sessions` (`session_id`, `expires`, `data`) VALUES
('89315SotEjTecl4HF0f7_uozTgo2qMiV', 1650663787, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"flash\":{},\"passport\":{\"user\":1}}'),
('B5KWdCHg8eS7tn1DM8q5PqGvP7pWwTpT', 1650664075, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"flash\":{},\"passport\":{}}'),
('b2fkIfnwhJuJFVzNDNg_95lwqcEg8kh8', 1650668630, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"flash\":{},\"passport\":{}}'),
('ba4etLWfqzftKDwDVAvPZPQKslfCiXXm', 1650686290, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"flash\":{}}'),
('xMiGyKGuTKA8X_ymMYedfi7PoN0DymiH', 1650674460, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"flash\":{},\"passport\":{\"user\":1}}');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `temperaturaaltaalumnos`
--

CREATE TABLE `temperaturaaltaalumnos` (
  `id` int NOT NULL,
  `RFID` varchar(64) NOT NULL,
  `matricula` varchar(64) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `temperatura` varchar(64) NOT NULL,
  `area` varchar(128) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `temperaturaaltaalumnos`
--

INSERT INTO `temperaturaaltaalumnos` (`id`, `RFID`, `matricula`, `nombre`, `apellidos`, `temperatura`, `area`, `fecha`) VALUES
(1, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '38.04001617', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:32:24'),
(2, '3284057353', '2172002786', 'Gabriel', 'Hurtado Aviles', '40.89999771', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:38:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `temperaturaaltaprofesoresypersonal`
--

CREATE TABLE `temperaturaaltaprofesoresypersonal` (
  `id` int NOT NULL,
  `clave` varchar(64) NOT NULL,
  `huella` varchar(64) NOT NULL,
  `noEmpleado` varchar(64) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `temperatura` varchar(64) NOT NULL,
  `area` varchar(128) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `temperaturaaltaprofesoresypersonal`
--

INSERT INTO `temperaturaaltaprofesoresypersonal` (`id`, `clave`, `huella`, `noEmpleado`, `nombre`, `apellidos`, `temperatura`, `area`, `fecha`) VALUES
(1, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '37.56000519', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:30:47'),
(2, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '40.34000015', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:52:12'),
(3, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '38.95999908', 'Laboratorio de Sistemas Digitales', '2022-04-19 22:58:23'),
(4, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '38.95999908', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:00:28'),
(5, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '39.8800087', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:06:41'),
(6, '2172002786', '3', '250515', 'Sara', 'Aguilar Ortega', '42.39999771', 'Laboratorio de Sistemas Digitales', '2022-04-19 23:41:47'),
(7, '2172002785', '2', '190315', 'Jose', 'Martinez Vargas', '38.82001495', 'Laboratorio de Sistemas Digitales', '2022-04-20 01:21:22');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  `fullname` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `fullname`) VALUES
(1, 'Gos2398', '$2a$10$n7aoV8DWLPn6bdgn5OmYd.sNh5wZWJYLpFuhnt5NYlENXsce7MSFC', 'Giovanni Olmos Salmones');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alumnos`
--
ALTER TABLE `alumnos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `matricula` (`matricula`);

--
-- Indices de la tabla `laboratoriosyaulas`
--
ALTER TABLE `laboratoriosyaulas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `profesoresypersonal`
--
ALTER TABLE `profesoresypersonal`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `noEmpleado` (`noEmpleado`);

--
-- Indices de la tabla `registroentradaalumnos`
--
ALTER TABLE `registroentradaalumnos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `RFID` (`RFID`);

--
-- Indices de la tabla `registroentradaalumnoshistorial`
--
ALTER TABLE `registroentradaalumnoshistorial`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `registroentradaprofesoresypersonal`
--
ALTER TABLE `registroentradaprofesoresypersonal`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `registroentradaprofesoresypersonalhistorial`
--
ALTER TABLE `registroentradaprofesoresypersonalhistorial`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `registrosalidaalumnos`
--
ALTER TABLE `registrosalidaalumnos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `registrosalidaalumnoshistorial`
--
ALTER TABLE `registrosalidaalumnoshistorial`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `registrosalidaprofesoresypersonalhistorial`
--
ALTER TABLE `registrosalidaprofesoresypersonalhistorial`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`);

--
-- Indices de la tabla `temperaturaaltaalumnos`
--
ALTER TABLE `temperaturaaltaalumnos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `temperaturaaltaprofesoresypersonal`
--
ALTER TABLE `temperaturaaltaprofesoresypersonal`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alumnos`
--
ALTER TABLE `alumnos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `laboratoriosyaulas`
--
ALTER TABLE `laboratoriosyaulas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `profesoresypersonal`
--
ALTER TABLE `profesoresypersonal`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `registroentradaalumnos`
--
ALTER TABLE `registroentradaalumnos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT de la tabla `registroentradaalumnoshistorial`
--
ALTER TABLE `registroentradaalumnoshistorial`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT de la tabla `registroentradaprofesoresypersonal`
--
ALTER TABLE `registroentradaprofesoresypersonal`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT de la tabla `registroentradaprofesoresypersonalhistorial`
--
ALTER TABLE `registroentradaprofesoresypersonalhistorial`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT de la tabla `registrosalidaalumnos`
--
ALTER TABLE `registrosalidaalumnos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT de la tabla `registrosalidaalumnoshistorial`
--
ALTER TABLE `registrosalidaalumnoshistorial`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT de la tabla `registrosalidaprofesoresypersonalhistorial`
--
ALTER TABLE `registrosalidaprofesoresypersonalhistorial`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT de la tabla `temperaturaaltaalumnos`
--
ALTER TABLE `temperaturaaltaalumnos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `temperaturaaltaprofesoresypersonal`
--
ALTER TABLE `temperaturaaltaprofesoresypersonal`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
