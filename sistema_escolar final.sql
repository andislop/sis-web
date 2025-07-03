-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-07-2025 a las 15:51:17
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema_escolar`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `actividades`
--

CREATE TABLE `actividades` (
  `id_actividad` int(11) NOT NULL,
  `nombre_actividad` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_creacion` date NOT NULL,
  `id_materia` int(11) NOT NULL,
  `id_periodo` int(11) NOT NULL,
  `ponderacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `actividades`
--

INSERT INTO `actividades` (`id_actividad`, `nombre_actividad`, `descripcion`, `fecha_creacion`, `id_materia`, `id_periodo`, `ponderacion`) VALUES
(15, 'Ensayo', 'Ensayo sobre la guia 1', '2025-07-04', 13, 13, 20);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciudades`
--

CREATE TABLE `ciudades` (
  `id_ciudad` int(11) NOT NULL,
  `id_estado` int(11) NOT NULL,
  `ciudad` varchar(150) NOT NULL,
  `capital` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `ciudades`
--

INSERT INTO `ciudades` (`id_ciudad`, `id_estado`, `ciudad`, `capital`) VALUES
(1, 1, 'Maroa', 0),
(2, 1, 'Puerto Ayacucho', 1),
(3, 1, 'San Fernando de Atabapo', 0),
(4, 2, 'Anaco', 0),
(5, 2, 'Aragua de Barcelona', 0),
(6, 2, 'Barcelona', 1),
(7, 2, 'Boca de Uchire', 0),
(8, 2, 'Cantaura', 0),
(9, 2, 'Clarines', 0),
(10, 2, 'El Chaparro', 0),
(11, 2, 'El Pao Anzoátegui', 0),
(12, 2, 'El Tigre', 0),
(13, 2, 'El Tigrito', 0),
(14, 2, 'Guanape', 0),
(15, 2, 'Guanta', 0),
(16, 2, 'Lechería', 0),
(17, 2, 'Onoto', 0),
(18, 2, 'Pariaguán', 0),
(19, 2, 'Píritu', 0),
(20, 2, 'Puerto La Cruz', 0),
(21, 2, 'Puerto Píritu', 0),
(22, 2, 'Sabana de Uchire', 0),
(23, 2, 'San Mateo Anzoátegui', 0),
(24, 2, 'San Pablo Anzoátegui', 0),
(25, 2, 'San Tomé', 0),
(26, 2, 'Santa Ana de Anzoátegui', 0),
(27, 2, 'Santa Fe Anzoátegui', 0),
(28, 2, 'Santa Rosa', 0),
(29, 2, 'Soledad', 0),
(30, 2, 'Urica', 0),
(31, 2, 'Valle de Guanape', 0),
(43, 3, 'Achaguas', 0),
(44, 3, 'Biruaca', 0),
(45, 3, 'Bruzual', 0),
(46, 3, 'El Amparo', 0),
(47, 3, 'El Nula', 0),
(48, 3, 'Elorza', 0),
(49, 3, 'Guasdualito', 0),
(50, 3, 'Mantecal', 0),
(51, 3, 'Puerto Páez', 0),
(52, 3, 'San Fernando de Apure', 1),
(53, 3, 'San Juan de Payara', 0),
(54, 4, 'Barbacoas', 0),
(55, 4, 'Cagua', 0),
(56, 4, 'Camatagua', 0),
(58, 4, 'Choroní', 0),
(59, 4, 'Colonia Tovar', 0),
(60, 4, 'El Consejo', 0),
(61, 4, 'La Victoria', 0),
(62, 4, 'Las Tejerías', 0),
(63, 4, 'Magdaleno', 0),
(64, 4, 'Maracay', 1),
(65, 4, 'Ocumare de La Costa', 0),
(66, 4, 'Palo Negro', 0),
(67, 4, 'San Casimiro', 0),
(68, 4, 'San Mateo', 0),
(69, 4, 'San Sebastián', 0),
(70, 4, 'Santa Cruz de Aragua', 0),
(71, 4, 'Tocorón', 0),
(72, 4, 'Turmero', 0),
(73, 4, 'Villa de Cura', 0),
(74, 4, 'Zuata', 0),
(75, 5, 'Barinas', 1),
(76, 5, 'Barinitas', 0),
(77, 5, 'Barrancas', 0),
(78, 5, 'Calderas', 0),
(79, 5, 'Capitanejo', 0),
(80, 5, 'Ciudad Bolivia', 0),
(81, 5, 'El Cantón', 0),
(82, 5, 'Las Veguitas', 0),
(83, 5, 'Libertad de Barinas', 0),
(84, 5, 'Sabaneta', 0),
(85, 5, 'Santa Bárbara de Barinas', 0),
(86, 5, 'Socopó', 0),
(87, 6, 'Caicara del Orinoco', 0),
(88, 6, 'Canaima', 0),
(89, 6, 'Ciudad Bolívar', 1),
(90, 6, 'Ciudad Piar', 0),
(91, 6, 'El Callao', 0),
(92, 6, 'El Dorado', 0),
(93, 6, 'El Manteco', 0),
(94, 6, 'El Palmar', 0),
(95, 6, 'El Pao', 0),
(96, 6, 'Guasipati', 0),
(97, 6, 'Guri', 0),
(98, 6, 'La Paragua', 0),
(99, 6, 'Matanzas', 0),
(100, 6, 'Puerto Ordaz', 0),
(101, 6, 'San Félix', 0),
(102, 6, 'Santa Elena de Uairén', 0),
(103, 6, 'Tumeremo', 0),
(104, 6, 'Unare', 0),
(105, 6, 'Upata', 0),
(106, 7, 'Bejuma', 0),
(107, 7, 'Belén', 0),
(108, 7, 'Campo de Carabobo', 0),
(109, 7, 'Canoabo', 0),
(110, 7, 'Central Tacarigua', 0),
(111, 7, 'Chirgua', 0),
(112, 7, 'Ciudad Alianza', 0),
(113, 7, 'El Palito', 0),
(114, 7, 'Guacara', 0),
(115, 7, 'Guigue', 0),
(116, 7, 'Las Trincheras', 0),
(117, 7, 'Los Guayos', 0),
(118, 7, 'Mariara', 0),
(119, 7, 'Miranda', 0),
(120, 7, 'Montalbán', 0),
(121, 7, 'Morón', 0),
(122, 7, 'Naguanagua', 0),
(123, 7, 'Puerto Cabello', 0),
(124, 7, 'San Joaquín', 0),
(125, 7, 'Tocuyito', 0),
(126, 7, 'Urama', 0),
(127, 7, 'Valencia', 1),
(128, 7, 'Vigirimita', 0),
(129, 8, 'Aguirre', 0),
(130, 8, 'Apartaderos Cojedes', 0),
(131, 8, 'Arismendi', 0),
(132, 8, 'Camuriquito', 0),
(133, 8, 'El Baúl', 0),
(134, 8, 'El Limón', 0),
(135, 8, 'El Pao Cojedes', 0),
(136, 8, 'El Socorro', 0),
(137, 8, 'La Aguadita', 0),
(138, 8, 'Las Vegas', 0),
(139, 8, 'Libertad de Cojedes', 0),
(140, 8, 'Mapuey', 0),
(141, 8, 'Piñedo', 0),
(142, 8, 'Samancito', 0),
(143, 8, 'San Carlos', 1),
(144, 8, 'Sucre', 0),
(145, 8, 'Tinaco', 0),
(146, 8, 'Tinaquillo', 0),
(147, 8, 'Vallecito', 0),
(148, 9, 'Tucupita', 1),
(149, 24, 'Caracas', 1),
(150, 24, 'El Junquito', 0),
(151, 10, 'Adícora', 0),
(152, 10, 'Boca de Aroa', 0),
(153, 10, 'Cabure', 0),
(154, 10, 'Capadare', 0),
(155, 10, 'Capatárida', 0),
(156, 10, 'Chichiriviche', 0),
(157, 10, 'Churuguara', 0),
(158, 10, 'Coro', 1),
(159, 10, 'Cumarebo', 0),
(160, 10, 'Dabajuro', 0),
(161, 10, 'Judibana', 0),
(162, 10, 'La Cruz de Taratara', 0),
(163, 10, 'La Vela de Coro', 0),
(164, 10, 'Los Taques', 0),
(165, 10, 'Maparari', 0),
(166, 10, 'Mene de Mauroa', 0),
(167, 10, 'Mirimire', 0),
(168, 10, 'Pedregal', 0),
(169, 10, 'Píritu Falcón', 0),
(170, 10, 'Pueblo Nuevo Falcón', 0),
(171, 10, 'Puerto Cumarebo', 0),
(172, 10, 'Punta Cardón', 0),
(173, 10, 'Punto Fijo', 0),
(174, 10, 'San Juan de Los Cayos', 0),
(175, 10, 'San Luis', 0),
(176, 10, 'Santa Ana Falcón', 0),
(177, 10, 'Santa Cruz De Bucaral', 0),
(178, 10, 'Tocopero', 0),
(179, 10, 'Tocuyo de La Costa', 0),
(180, 10, 'Tucacas', 0),
(181, 10, 'Yaracal', 0),
(182, 11, 'Altagracia de Orituco', 0),
(183, 11, 'Cabruta', 0),
(184, 11, 'Calabozo', 0),
(185, 11, 'Camaguán', 0),
(196, 11, 'Chaguaramas Guárico', 0),
(197, 11, 'El Socorro', 0),
(198, 11, 'El Sombrero', 0),
(199, 11, 'Las Mercedes de Los Llanos', 0),
(200, 11, 'Lezama', 0),
(201, 11, 'Onoto', 0),
(202, 11, 'Ortíz', 0),
(203, 11, 'San José de Guaribe', 0),
(204, 11, 'San Juan de Los Morros', 1),
(205, 11, 'San Rafael de Laya', 0),
(206, 11, 'Santa María de Ipire', 0),
(207, 11, 'Tucupido', 0),
(208, 11, 'Valle de La Pascua', 0),
(209, 11, 'Zaraza', 0),
(210, 12, 'Aguada Grande', 0),
(211, 12, 'Atarigua', 0),
(212, 12, 'Barquisimeto', 1),
(213, 12, 'Bobare', 0),
(214, 12, 'Cabudare', 0),
(215, 12, 'Carora', 0),
(216, 12, 'Cubiro', 0),
(217, 12, 'Cují', 0),
(218, 12, 'Duaca', 0),
(219, 12, 'El Manzano', 0),
(220, 12, 'El Tocuyo', 0),
(221, 12, 'Guaríco', 0),
(222, 12, 'Humocaro Alto', 0),
(223, 12, 'Humocaro Bajo', 0),
(224, 12, 'La Miel', 0),
(225, 12, 'Moroturo', 0),
(226, 12, 'Quíbor', 0),
(227, 12, 'Río Claro', 0),
(228, 12, 'Sanare', 0),
(229, 12, 'Santa Inés', 0),
(230, 12, 'Sarare', 0),
(231, 12, 'Siquisique', 0),
(232, 12, 'Tintorero', 0),
(233, 13, 'Apartaderos Mérida', 0),
(234, 13, 'Arapuey', 0),
(235, 13, 'Bailadores', 0),
(236, 13, 'Caja Seca', 0),
(237, 13, 'Canaguá', 0),
(238, 13, 'Chachopo', 0),
(239, 13, 'Chiguara', 0),
(240, 13, 'Ejido', 0),
(241, 13, 'El Vigía', 0),
(242, 13, 'La Azulita', 0),
(243, 13, 'La Playa', 0),
(244, 13, 'Lagunillas Mérida', 0),
(245, 13, 'Mérida', 1),
(246, 13, 'Mesa de Bolívar', 0),
(247, 13, 'Mucuchíes', 0),
(248, 13, 'Mucujepe', 0),
(249, 13, 'Mucuruba', 0),
(250, 13, 'Nueva Bolivia', 0),
(251, 13, 'Palmarito', 0),
(252, 13, 'Pueblo Llano', 0),
(253, 13, 'Santa Cruz de Mora', 0),
(254, 13, 'Santa Elena de Arenales', 0),
(255, 13, 'Santo Domingo', 0),
(256, 13, 'Tabáy', 0),
(257, 13, 'Timotes', 0),
(258, 13, 'Torondoy', 0),
(259, 13, 'Tovar', 0),
(260, 13, 'Tucani', 0),
(261, 13, 'Zea', 0),
(262, 14, 'Araguita', 0),
(263, 14, 'Carrizal', 0),
(264, 14, 'Caucagua', 0),
(265, 14, 'Chaguaramas Miranda', 0),
(266, 14, 'Charallave', 0),
(267, 14, 'Chirimena', 0),
(268, 14, 'Chuspa', 0),
(269, 14, 'Cúa', 0),
(270, 14, 'Cupira', 0),
(271, 14, 'Curiepe', 0),
(272, 14, 'El Guapo', 0),
(273, 14, 'El Jarillo', 0),
(274, 14, 'Filas de Mariche', 0),
(275, 14, 'Guarenas', 0),
(276, 14, 'Guatire', 0),
(277, 14, 'Higuerote', 0),
(278, 14, 'Los Anaucos', 0),
(279, 14, 'Los Teques', 1),
(280, 14, 'Ocumare del Tuy', 0),
(281, 14, 'Panaquire', 0),
(282, 14, 'Paracotos', 0),
(283, 14, 'Río Chico', 0),
(284, 14, 'San Antonio de Los Altos', 0),
(285, 14, 'San Diego de Los Altos', 0),
(286, 14, 'San Fernando del Guapo', 0),
(287, 14, 'San Francisco de Yare', 0),
(288, 14, 'San José de Los Altos', 0),
(289, 14, 'San José de Río Chico', 0),
(290, 14, 'San Pedro de Los Altos', 0),
(291, 14, 'Santa Lucía', 0),
(292, 14, 'Santa Teresa', 0),
(293, 14, 'Tacarigua de La Laguna', 0),
(294, 14, 'Tacarigua de Mamporal', 0),
(295, 14, 'Tácata', 0),
(296, 14, 'Turumo', 0),
(297, 15, 'Aguasay', 0),
(298, 15, 'Aragua de Maturín', 0),
(299, 15, 'Barrancas del Orinoco', 0),
(300, 15, 'Caicara de Maturín', 0),
(301, 15, 'Caripe', 0),
(302, 15, 'Caripito', 0),
(303, 15, 'Chaguaramal', 0),
(305, 15, 'Chaguaramas Monagas', 0),
(307, 15, 'El Furrial', 0),
(308, 15, 'El Tejero', 0),
(309, 15, 'Jusepín', 0),
(310, 15, 'La Toscana', 0),
(311, 15, 'Maturín', 1),
(312, 15, 'Miraflores', 0),
(313, 15, 'Punta de Mata', 0),
(314, 15, 'Quiriquire', 0),
(315, 15, 'San Antonio de Maturín', 0),
(316, 15, 'San Vicente Monagas', 0),
(317, 15, 'Santa Bárbara', 0),
(318, 15, 'Temblador', 0),
(319, 15, 'Teresen', 0),
(320, 15, 'Uracoa', 0),
(321, 16, 'Altagracia', 0),
(322, 16, 'Boca de Pozo', 0),
(323, 16, 'Boca de Río', 0),
(324, 16, 'El Espinal', 0),
(325, 16, 'El Valle del Espíritu Santo', 0),
(326, 16, 'El Yaque', 0),
(327, 16, 'Juangriego', 0),
(328, 16, 'La Asunción', 1),
(329, 16, 'La Guardia', 0),
(330, 16, 'Pampatar', 0),
(331, 16, 'Porlamar', 0),
(332, 16, 'Puerto Fermín', 0),
(333, 16, 'Punta de Piedras', 0),
(334, 16, 'San Francisco de Macanao', 0),
(335, 16, 'San Juan Bautista', 0),
(336, 16, 'San Pedro de Coche', 0),
(337, 16, 'Santa Ana de Nueva Esparta', 0),
(338, 16, 'Villa Rosa', 0),
(339, 17, 'Acarigua', 0),
(340, 17, 'Agua Blanca', 0),
(341, 17, 'Araure', 0),
(342, 17, 'Biscucuy', 0),
(343, 17, 'Boconoito', 0),
(344, 17, 'Campo Elías', 0),
(345, 17, 'Chabasquén', 0),
(346, 17, 'Guanare', 1),
(347, 17, 'Guanarito', 0),
(348, 17, 'La Aparición', 0),
(349, 17, 'La Misión', 0),
(350, 17, 'Mesa de Cavacas', 0),
(351, 17, 'Ospino', 0),
(352, 17, 'Papelón', 0),
(353, 17, 'Payara', 0),
(354, 17, 'Pimpinela', 0),
(355, 17, 'Píritu de Portuguesa', 0),
(356, 17, 'San Rafael de Onoto', 0),
(357, 17, 'Santa Rosalía', 0),
(358, 17, 'Turén', 0),
(359, 18, 'Altos de Sucre', 0),
(360, 18, 'Araya', 0),
(361, 18, 'Cariaco', 0),
(362, 18, 'Carúpano', 0),
(363, 18, 'Casanay', 0),
(364, 18, 'Cumaná', 1),
(365, 18, 'Cumanacoa', 0),
(366, 18, 'El Morro Puerto Santo', 0),
(367, 18, 'El Pilar', 0),
(368, 18, 'El Poblado', 0),
(369, 18, 'Guaca', 0),
(370, 18, 'Guiria', 0),
(371, 18, 'Irapa', 0),
(372, 18, 'Manicuare', 0),
(373, 18, 'Mariguitar', 0),
(374, 18, 'Río Caribe', 0),
(375, 18, 'San Antonio del Golfo', 0),
(376, 18, 'San José de Aerocuar', 0),
(377, 18, 'San Vicente de Sucre', 0),
(378, 18, 'Santa Fe de Sucre', 0),
(379, 18, 'Tunapuy', 0),
(380, 18, 'Yaguaraparo', 0),
(381, 18, 'Yoco', 0),
(382, 19, 'Abejales', 0),
(383, 19, 'Borota', 0),
(384, 19, 'Bramon', 0),
(385, 19, 'Capacho', 0),
(386, 19, 'Colón', 0),
(387, 19, 'Coloncito', 0),
(388, 19, 'Cordero', 0),
(389, 19, 'El Cobre', 0),
(390, 19, 'El Pinal', 0),
(391, 19, 'Independencia', 0),
(392, 19, 'La Fría', 0),
(393, 19, 'La Grita', 0),
(394, 19, 'La Pedrera', 0),
(395, 19, 'La Tendida', 0),
(396, 19, 'Las Delicias', 0),
(397, 19, 'Las Hernández', 0),
(398, 19, 'Lobatera', 0),
(399, 19, 'Michelena', 0),
(400, 19, 'Palmira', 0),
(401, 19, 'Pregonero', 0),
(402, 19, 'Queniquea', 0),
(403, 19, 'Rubio', 0),
(404, 19, 'San Antonio del Tachira', 0),
(405, 19, 'San Cristobal', 1),
(406, 19, 'San José de Bolívar', 0),
(407, 19, 'San Josecito', 0),
(408, 19, 'San Pedro del Río', 0),
(409, 19, 'Santa Ana Táchira', 0),
(410, 19, 'Seboruco', 0),
(411, 19, 'Táriba', 0),
(412, 19, 'Umuquena', 0),
(413, 19, 'Ureña', 0),
(414, 20, 'Batatal', 0),
(415, 20, 'Betijoque', 0),
(416, 20, 'Boconó', 0),
(417, 20, 'Carache', 0),
(418, 20, 'Chejende', 0),
(419, 20, 'Cuicas', 0),
(420, 20, 'El Dividive', 0),
(421, 20, 'El Jaguito', 0),
(422, 20, 'Escuque', 0),
(423, 20, 'Isnotú', 0),
(424, 20, 'Jajó', 0),
(425, 20, 'La Ceiba', 0),
(426, 20, 'La Concepción de Trujllo', 0),
(427, 20, 'La Mesa de Esnujaque', 0),
(428, 20, 'La Puerta', 0),
(429, 20, 'La Quebrada', 0),
(430, 20, 'Mendoza Fría', 0),
(431, 20, 'Meseta de Chimpire', 0),
(432, 20, 'Monay', 0),
(433, 20, 'Motatán', 0),
(434, 20, 'Pampán', 0),
(435, 20, 'Pampanito', 0),
(436, 20, 'Sabana de Mendoza', 0),
(437, 20, 'San Lázaro', 0),
(438, 20, 'Santa Ana de Trujillo', 0),
(439, 20, 'Tostós', 0),
(440, 20, 'Trujillo', 1),
(441, 20, 'Valera', 0),
(442, 21, 'Carayaca', 0),
(443, 21, 'Litoral', 0),
(444, 25, 'Archipiélago Los Roques', 0),
(445, 22, 'Aroa', 0),
(446, 22, 'Boraure', 0),
(447, 22, 'Campo Elías de Yaracuy', 0),
(448, 22, 'Chivacoa', 0),
(449, 22, 'Cocorote', 0),
(450, 22, 'Farriar', 0),
(451, 22, 'Guama', 0),
(452, 22, 'Marín', 0),
(453, 22, 'Nirgua', 0),
(454, 22, 'Sabana de Parra', 0),
(455, 22, 'Salom', 0),
(456, 22, 'San Felipe', 1),
(457, 22, 'San Pablo de Yaracuy', 0),
(458, 22, 'Urachiche', 0),
(459, 22, 'Yaritagua', 0),
(460, 22, 'Yumare', 0),
(461, 23, 'Bachaquero', 0),
(462, 23, 'Bobures', 0),
(463, 23, 'Cabimas', 0),
(464, 23, 'Campo Concepción', 0),
(465, 23, 'Campo Mara', 0),
(466, 23, 'Campo Rojo', 0),
(467, 23, 'Carrasquero', 0),
(468, 23, 'Casigua', 0),
(469, 23, 'Chiquinquirá', 0),
(470, 23, 'Ciudad Ojeda', 0),
(471, 23, 'El Batey', 0),
(472, 23, 'El Carmelo', 0),
(473, 23, 'El Chivo', 0),
(474, 23, 'El Guayabo', 0),
(475, 23, 'El Mene', 0),
(476, 23, 'El Venado', 0),
(477, 23, 'Encontrados', 0),
(478, 23, 'Gibraltar', 0),
(479, 23, 'Isla de Toas', 0),
(480, 23, 'La Concepción del Zulia', 0),
(481, 23, 'La Paz', 0),
(482, 23, 'La Sierrita', 0),
(483, 23, 'Lagunillas del Zulia', 0),
(484, 23, 'Las Piedras de Perijá', 0),
(485, 23, 'Los Cortijos', 0),
(486, 23, 'Machiques', 0),
(487, 23, 'Maracaibo', 1),
(488, 23, 'Mene Grande', 0),
(489, 23, 'Palmarejo', 0),
(490, 23, 'Paraguaipoa', 0),
(491, 23, 'Potrerito', 0),
(492, 23, 'Pueblo Nuevo del Zulia', 0),
(493, 23, 'Puertos de Altagracia', 0),
(494, 23, 'Punta Gorda', 0),
(495, 23, 'Sabaneta de Palma', 0),
(496, 23, 'San Francisco', 0),
(497, 23, 'San José de Perijá', 0),
(498, 23, 'San Rafael del Moján', 0),
(499, 23, 'San Timoteo', 0),
(500, 23, 'Santa Bárbara Del Zulia', 0),
(501, 23, 'Santa Cruz de Mara', 0),
(502, 23, 'Santa Cruz del Zulia', 0),
(503, 23, 'Santa Rita', 0),
(504, 23, 'Sinamaica', 0),
(505, 23, 'Tamare', 0),
(506, 23, 'Tía Juana', 0),
(507, 23, 'Villa del Rosario', 0),
(508, 21, 'La Guaira', 1),
(509, 21, 'Catia La Mar', 0),
(510, 21, 'Macuto', 0),
(511, 21, 'Naiguatá', 0),
(512, 25, 'Archipiélago Los Monjes', 0),
(513, 25, 'Isla La Tortuga y Cayos adyacentes', 0),
(514, 25, 'Isla La Sola', 0),
(515, 25, 'Islas Los Testigos', 0),
(516, 25, 'Islas Los Frailes', 0),
(517, 25, 'Isla La Orchila', 0),
(518, 25, 'Archipiélago Las Aves', 0),
(519, 25, 'Isla de Aves', 0),
(520, 25, 'Isla La Blanquilla', 0),
(521, 25, 'Isla de Patos', 0),
(522, 25, 'Islas Los Hermanos', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `codigos_recuperacion`
--

CREATE TABLE `codigos_recuperacion` (
  `id` int(11) NOT NULL,
  `correo` varchar(255) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `expiracion` datetime NOT NULL,
  `usado` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `codigos_recuperacion`
--

INSERT INTO `codigos_recuperacion` (`id`, `correo`, `codigo`, `expiracion`, `usado`, `created_at`) VALUES
(1, 'andislopez123@gmail.com', '277284', '2025-06-26 12:14:15', 1, '2025-06-26 15:59:15'),
(2, 'andislopez123@gmail.com', '120920', '2025-06-26 12:14:38', 1, '2025-06-26 15:59:38'),
(3, 'andislopez123@gmail.com', '796844', '2025-06-26 12:15:57', 1, '2025-06-26 16:00:57'),
(4, 'andislopez123@gmail.com', '994203', '2025-06-26 12:21:59', 1, '2025-06-26 16:06:59'),
(5, 'andislopez123@gmail.com', '367974', '2025-06-26 12:24:55', 1, '2025-06-26 16:09:55'),
(6, 'andislopez123@gmail.com', '356264', '2025-06-26 12:27:19', 1, '2025-06-26 16:12:19'),
(7, 'andislopez123@gmail.com', '451748', '2025-06-26 12:28:15', 1, '2025-06-26 16:13:15'),
(8, 'andislopez123@gmail.com', '789233', '2025-06-26 12:30:27', 1, '2025-06-26 16:15:27'),
(9, 'andislopez123@gmail.com', '346317', '2025-06-26 12:32:42', 1, '2025-06-26 16:17:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentarios`
--

CREATE TABLE `comentarios` (
  `id_comentario` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `mensaje` text NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `id_actividad` int(11) NOT NULL,
  `leido_por_estudiante` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `comentarios`
--

INSERT INTO `comentarios` (`id_comentario`, `id_estudiante`, `id_usuario`, `mensaje`, `fecha_hora`, `id_actividad`, `leido_por_estudiante`) VALUES
(34, 18, 21, 'Muy Bien', '2025-07-03 09:50:10', 15, 0),
(35, 1, 21, 'Puedes mejorar', '2025-07-03 09:50:10', 15, 0),
(36, 29, 21, 'Debes practicar', '2025-07-03 09:50:10', 15, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos`
--

CREATE TABLE `cursos` (
  `id_curso` int(11) NOT NULL,
  `curso` varchar(45) NOT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `cursos`
--

INSERT INTO `cursos` (`id_curso`, `curso`, `activo`) VALUES
(1, 'Matemática', 1),
(2, 'Ciencias Naturales', 1),
(3, 'Ciencias Naturales', 1),
(4, 'Historia Universal', 0),
(5, 'Lenguaje y Literatura', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos_materias`
--

CREATE TABLE `cursos_materias` (
  `id_curso_materia` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `id_curso` int(11) NOT NULL,
  `id_materia` int(11) NOT NULL,
  `id_periodo` int(11) NOT NULL,
  `id_nota` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `cursos_materias`
--

INSERT INTO `cursos_materias` (`id_curso_materia`, `id_estudiante`, `id_curso`, `id_materia`, `id_periodo`, `id_nota`) VALUES
(1, 1, 1, 4, 3, 1),
(2, 18, 3, 4, 2, 2),
(3, 18, 2, 4, 2, 3),
(4, 18, 1, 5, 5, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos_periodo`
--

CREATE TABLE `cursos_periodo` (
  `id_curso_periodo` int(11) NOT NULL,
  `id_curso` int(11) NOT NULL,
  `id_periodo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `cursos_periodo`
--

INSERT INTO `cursos_periodo` (`id_curso_periodo`, `id_curso`, `id_periodo`) VALUES
(14, 1, 12),
(15, 2, 12),
(16, 3, 12),
(17, 5, 13);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos_seccion`
--

CREATE TABLE `cursos_seccion` (
  `id_cursos_seccion` int(11) NOT NULL,
  `id_curso` int(11) DEFAULT NULL,
  `id_seccion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cursos_seccion`
--

INSERT INTO `cursos_seccion` (`id_cursos_seccion`, `id_curso`, `id_seccion`) VALUES
(1, 1, 1),
(2, 13, 1),
(3, 8, 1),
(4, 5, 3),
(5, 6, 2),
(6, 7, 1),
(7, 2, 3),
(8, 3, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direccion`
--

CREATE TABLE `direccion` (
  `id_direccion` int(11) NOT NULL,
  `direccion` varchar(45) NOT NULL,
  `id_ciudad` int(11) NOT NULL,
  `id_estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `direccion`
--

INSERT INTO `direccion` (`id_direccion`, `direccion`, `id_ciudad`, `id_estado`) VALUES
(1, 'oo', 4, 12),
(2, 'g', 212, 12),
(3, 'g', 212, 12),
(4, 'g', 212, 12),
(5, '123', 227, 12),
(6, '1234', 227, 12),
(7, '123', 248, 13),
(8, 'g', 277, 14),
(9, 'g', 277, 14),
(10, 'g', 277, 14),
(11, 'Calle 30 entre carreras 15 y 16', 225, 12),
(12, 'frente al farmatodo del centro', 55, 4),
(13, '45 entre 23 y 24', 224, 12),
(14, 'oog', 1, 1),
(15, 'oogg', 1, 1),
(16, 'oogF', 1, 1),
(17, 'calle 45', 1, 1),
(18, '0', 278, 14),
(19, 'g', 247, 13),
(20, 'g', 247, 13),
(21, '2', 226, 12),
(22, 'el tostado', 225, 12),
(23, 'gg', 279, 14),
(24, 'sadsa', 143, 8),
(25, 'sdfdsdfsdf', 212, 12),
(26, 'Calle 30 entre carreras 15 y 16', 226, 12),
(27, '15 con 52', 227, 12),
(28, 'g', 212, 12),
(29, 'la botella', 442, 21),
(30, '123', 225, 12),
(31, '123', 149, 24),
(32, 'g', 278, 14),
(33, 'playa', 212, 12),
(34, 'calle 15', 212, 12),
(35, 'dfgdfg', 223, 12),
(36, 'Calle 13', 316, 15);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estados`
--

CREATE TABLE `estados` (
  `id_estado` int(11) NOT NULL,
  `estados` varchar(45) NOT NULL,
  `iso-3166-2` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `estados`
--

INSERT INTO `estados` (`id_estado`, `estados`, `iso-3166-2`) VALUES
(1, 'Amazonas', 'VE-X'),
(2, 'Anzoátegui', 'VE-B'),
(3, 'Apure', 'VE-C'),
(4, 'Aragua', 'VE-D'),
(5, 'Barinas', 'VE-E'),
(6, 'Bolívar', 'VE-F'),
(7, 'Carabobo', 'VE-G'),
(8, 'Cojedes', 'VE-H'),
(9, 'Delta Amacuro', 'VE-Y'),
(10, 'Falcón', 'VE-I'),
(11, 'Guárico', 'VE-J'),
(12, 'Lara', 'VE-K'),
(13, 'Mérida', 'VE-L'),
(14, 'Miranda', 'VE-M'),
(15, 'Monagas', 'VE-N'),
(16, 'Nueva Esparta', 'VE-O'),
(17, 'Portuguesa', 'VE-P'),
(18, 'Sucre', 'VE-R'),
(19, 'Táchira', 'VE-S'),
(20, 'Trujillo', 'VE-T'),
(21, 'La Guaira', 'VE-W'),
(22, 'Yaracuy', 'VE-U'),
(23, 'Zulia', 'VE-V'),
(24, 'Distrito Capital', 'VE-A'),
(25, 'Dependencias Federales', 'VE-Z');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiantes`
--

CREATE TABLE `estudiantes` (
  `id_estudiante` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `estudiantes`
--

INSERT INTO `estudiantes` (`id_estudiante`, `id_usuario`) VALUES
(1, 1),
(3, 11),
(11, 11),
(12, 12),
(19, 12),
(2, 13),
(13, 13),
(18, 18),
(22, 22),
(23, 23),
(24, 25),
(25, 29),
(29, 29),
(30, 30);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_acciones`
--

CREATE TABLE `historial_acciones` (
  `id_historial` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `accion` varchar(255) NOT NULL,
  `tabla_afectada` varchar(50) DEFAULT NULL,
  `id_registro_afectado` int(11) DEFAULT NULL,
  `datos_anteriores` text DEFAULT NULL,
  `datos_nuevos` text DEFAULT NULL,
  `fecha_hora` datetime NOT NULL,
  `ip` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_acciones`
--

INSERT INTO `historial_acciones` (`id_historial`, `id_usuario`, `accion`, `tabla_afectada`, `id_registro_afectado`, `datos_anteriores`, `datos_nuevos`, `fecha_hora`, `ip`) VALUES
(1, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 15:46:21', '::1'),
(2, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 16:22:32', '::1'),
(3, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 17:01:26', '::1'),
(4, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 17:11:04', '::1'),
(5, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 17:43:18', '::1'),
(6, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 18:23:57', '::1'),
(7, 22, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 18:27:22', '::1'),
(8, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 18:27:40', '::1'),
(9, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 18:35:46', '::1'),
(10, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 19:17:18', '::1'),
(11, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 19:22:43', '::1'),
(12, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 19:23:15', '::1'),
(13, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 19:27:06', '::1'),
(14, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-23 19:27:09', '::1'),
(15, 17, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 19:28:26', '::1'),
(16, 17, 'Logout', NULL, NULL, NULL, NULL, '2025-06-23 19:28:51', '::1'),
(17, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 19:28:53', '::1'),
(18, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 20:00:23', '::1'),
(19, 9, 'Actualización de perfil', 'usuarios', 9, '{}', '{\"message\":\"Perfil actualizado exitosamente.\"}', '2025-06-23 20:00:37', '::1'),
(20, 19, 'Intento fallido de login', NULL, NULL, NULL, NULL, '2025-06-23 21:29:00', '::1'),
(21, 19, 'Intento fallido de login', NULL, NULL, NULL, NULL, '2025-06-23 21:29:02', '::1'),
(22, 19, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 21:29:05', '::1'),
(23, 19, 'Logout', NULL, NULL, NULL, NULL, '2025-06-23 21:30:19', '::1'),
(24, 11, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 21:30:28', '::1'),
(25, 11, 'Logout', NULL, NULL, NULL, NULL, '2025-06-23 21:30:37', '::1'),
(26, 11, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 21:31:34', '::1'),
(27, 11, 'Logout', NULL, NULL, NULL, NULL, '2025-06-23 21:31:45', '::1'),
(28, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 21:31:53', '::1'),
(29, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 21:34:03', '::1'),
(30, 18, 'Logout', NULL, NULL, NULL, NULL, '2025-06-23 21:47:19', '::1'),
(31, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 21:47:21', '::1'),
(32, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 22:00:46', '::1'),
(33, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 22:02:52', '::1'),
(34, 18, 'Logout', NULL, NULL, NULL, NULL, '2025-06-23 22:30:04', '::1'),
(35, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 22:30:05', '::1'),
(36, 18, 'Logout', NULL, NULL, NULL, NULL, '2025-06-23 22:34:37', '::1'),
(37, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 22:37:38', '::1'),
(38, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 22:43:12', '::1'),
(39, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 22:45:29', '::1'),
(40, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 22:48:50', '::1'),
(41, 18, 'Logout', NULL, NULL, NULL, NULL, '2025-06-23 22:54:47', '::1'),
(42, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 22:54:52', '::1'),
(43, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-23 22:56:26', '::1'),
(44, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 22:56:29', '::1'),
(45, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 23:17:40', '::1'),
(46, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-23 23:43:26', '::1'),
(47, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 00:52:05', '::1'),
(48, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 01:38:53', '::1'),
(49, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 17:03:39', '::1'),
(50, 18, 'Logout', NULL, NULL, NULL, NULL, '2025-06-24 17:07:50', '::1'),
(51, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 17:07:55', '::1'),
(52, 9, 'Asignación de rol a usuario', 'usuarios', NULL, NULL, '{\"message\":\"Usuario asignado y registrado correctamente.\"}', '2025-06-24 17:13:21', '::1'),
(53, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 18:54:28', '::1'),
(54, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 20:13:11', '::1'),
(55, 25, 'Registro de nuevo usuario', 'usuarios', 25, NULL, '{\"success\":true,\"message\":\"Usuario registrado. Espera aprobación del administrador.\",\"usuario\":{\"id_usuario\":25,\"cedula\":\"1232131\"}}', '2025-06-24 21:27:58', '::1'),
(56, 26, 'Registro de nuevo usuario', 'usuarios', 26, NULL, '{\"success\":true,\"message\":\"Usuario registrado. Espera aprobación del administrador.\",\"usuario\":{\"id_usuario\":26,\"cedula\":\"122111\"}}', '2025-06-24 21:29:17', '::1'),
(57, 27, 'Registro de nuevo usuario', 'usuarios', 27, NULL, '{\"success\":true,\"message\":\"Usuario registrado. Espera aprobación del administrador.\",\"usuario\":{\"id_usuario\":27,\"cedula\":\"2456524\"}}', '2025-06-24 21:30:41', '::1'),
(58, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 21:34:31', '::1'),
(59, 9, 'Asignación de rol a usuario', 'usuarios', NULL, NULL, '{\"message\":\"Usuario asignado y registrado correctamente.\"}', '2025-06-24 21:37:12', '::1'),
(60, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 21:41:51', '::1'),
(61, 9, 'Asignación de rol a usuario', 'usuarios', NULL, NULL, '{\"message\":\"Usuario asignado y registrado correctamente.\"}', '2025-06-24 21:41:59', '::1'),
(62, 9, 'Asignación de rol a usuario', 'usuarios', NULL, NULL, '{\"message\":\"Usuario asignado y registrado correctamente.\"}', '2025-06-24 21:42:05', '::1'),
(63, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 21:42:59', '::1'),
(64, 9, 'Asignación de rol a usuario', 'usuarios', NULL, NULL, '{\"message\":\"Usuario asignado y registrado correctamente.\"}', '2025-06-24 21:43:15', '::1'),
(65, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 21:49:24', '::1'),
(66, 9, 'Asignación de rol a usuario', 'usuarios', NULL, NULL, '{\"message\":\"Usuario asignado y registrado correctamente.\"}', '2025-06-24 21:49:31', '::1'),
(67, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-24 21:49:49', '::1'),
(68, 28, 'Registro de nuevo usuario', 'usuarios', 28, NULL, '{\"success\":true,\"message\":\"Usuario registrado. Espera aprobación del administrador.\",\"usuario\":{\"id_usuario\":28,\"cedula\":\"1231211\"}}', '2025-06-24 21:50:16', '::1'),
(69, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 21:50:44', '::1'),
(70, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 22:05:59', '::1'),
(71, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 22:25:33', '::1'),
(72, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 22:33:26', '::1'),
(73, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-24 22:40:08', '::1'),
(74, 9, 'Asignación de rol a usuario', 'usuarios', NULL, NULL, '{\"message\":\"Usuario asignado y registrado correctamente.\"}', '2025-06-24 22:40:22', '::1'),
(75, 9, 'Registro de Nota Individual', 'notas', NULL, NULL, '{\"message\":\"Nota y comentario registrados/actualizados correctamente.\"}', '2025-06-24 22:40:54', '::1'),
(76, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-25 00:14:44', '::1'),
(77, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 14:43:08', '::1'),
(78, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-26 15:09:34', '::1'),
(79, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 15:46:45', '::1'),
(80, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-26 15:46:48', '::1'),
(81, 29, 'Registro de nuevo usuario', 'usuarios', NULL, NULL, '{\"success\":true,\"message\":\"Usuario registrado. Espera aprobación del administrador.\",\"usuario\":{\"id_usuario\":29,\"cedula\":\"28539837\"}}', '2025-06-26 15:58:37', '::1'),
(82, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 15:58:42', '::1'),
(83, 9, 'Asignación de rol a usuario', 'usuarios', NULL, NULL, '{\"message\":\"Usuario asignado y registrado correctamente.\"}', '2025-06-26 15:59:03', '::1'),
(84, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-26 15:59:05', '::1'),
(85, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 16:19:05', '::1'),
(86, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-26 16:19:10', '::1'),
(87, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 16:19:18', '::1'),
(88, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-26 16:19:23', '::1'),
(89, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 23:36:00', '::1'),
(90, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-26 23:36:07', '::1'),
(91, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 23:36:15', '::1'),
(92, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-26 23:36:24', '::1'),
(93, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 23:36:30', '::1'),
(94, 18, 'Logout', NULL, NULL, NULL, NULL, '2025-06-26 23:45:44', '::1'),
(95, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 23:46:32', '::1'),
(96, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-26 23:47:46', '::1'),
(97, 18, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 23:47:49', '::1'),
(98, 18, 'Logout', NULL, NULL, NULL, NULL, '2025-06-26 23:48:01', '::1'),
(99, 8, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 23:48:06', '::1'),
(100, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-26 23:48:11', '::1'),
(101, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-27 23:15:12', '::1'),
(102, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 00:05:03', '::1'),
(103, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 03:40:53', '::1'),
(104, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 04:53:43', '::1'),
(105, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 04:56:29', '::1'),
(106, 9, 'Registro de notas por lote', 'notas', NULL, NULL, '{\"message\":\"Notas y comentarios registrados/actualizados correctamente.\"}', '2025-06-28 04:56:41', '::1'),
(107, 9, 'Registro de Nota Individual', 'notas', NULL, NULL, '{\"message\":\"Nota y comentario registrados/actualizados correctamente.\"}', '2025-06-28 04:57:17', '::1'),
(108, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 12:42:56', '::1'),
(109, 9, 'Registro de notas por lote', 'notas', NULL, NULL, '{\"message\":\"Notas y comentarios registrados/actualizados correctamente.\"}', '2025-06-28 12:52:03', '::1'),
(110, 14, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 16:08:48', '::1'),
(111, 14, 'Registro de notas por lote', 'notas', NULL, NULL, '{\"message\":\"Notas y comentarios registrados/actualizados correctamente.\"}', '2025-06-28 16:16:09', '::1'),
(112, 14, 'Logout', NULL, NULL, NULL, NULL, '2025-06-28 16:16:19', '::1'),
(113, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 16:18:02', '::1'),
(114, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 22:33:29', '::1'),
(115, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-28 22:40:41', '::1'),
(116, 29, 'Intento fallido de login', NULL, NULL, NULL, NULL, '2025-06-28 22:40:50', '::1'),
(117, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 22:40:55', '::1'),
(118, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-28 22:49:33', '::1'),
(119, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 22:49:35', '::1'),
(120, 9, 'Registro de notas por lote', 'notas', NULL, NULL, '{\"message\":\"Notas y comentarios registrados/actualizados correctamente.\"}', '2025-06-28 22:50:16', '::1'),
(121, 9, 'Registro de notas por lote', 'notas', NULL, NULL, '{\"message\":\"Notas y comentarios registrados/actualizados correctamente.\"}', '2025-06-28 22:51:51', '::1'),
(122, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-28 22:51:55', '::1'),
(123, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 22:52:01', '::1'),
(124, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-28 22:52:45', '::1'),
(125, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 22:52:47', '::1'),
(126, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-28 22:54:32', '::1'),
(127, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 22:54:42', '::1'),
(128, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 23:00:18', '::1'),
(129, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-28 23:00:23', '::1'),
(130, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 23:00:34', '::1'),
(131, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 23:02:35', '::1'),
(132, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 23:04:57', '::1'),
(133, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 23:07:57', '::1'),
(134, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 23:10:05', '::1'),
(135, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-28 23:10:45', '::1'),
(136, 11, 'Intento fallido de login', NULL, NULL, NULL, NULL, '2025-06-28 23:36:05', '::1'),
(137, 11, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 23:36:08', '::1'),
(138, 11, 'Logout', NULL, NULL, NULL, NULL, '2025-06-28 23:36:38', '::1'),
(139, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 23:36:46', '::1'),
(140, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 23:49:32', '::1'),
(141, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-28 23:52:15', '::1'),
(142, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 00:00:58', '::1'),
(143, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:05:36', '::1'),
(144, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 00:08:22', '::1'),
(145, 14, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:08:49', '::1'),
(146, 14, 'Intento fallido de login', NULL, NULL, NULL, NULL, '2025-06-29 00:12:36', '::1'),
(147, 14, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:12:39', '::1'),
(148, 14, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 00:12:52', '::1'),
(149, 19, 'Intento fallido de login', NULL, NULL, NULL, NULL, '2025-06-29 00:13:33', '::1'),
(150, 19, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:13:37', '::1'),
(151, 19, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:20:00', '::1'),
(152, 19, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 00:20:27', '::1'),
(153, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:20:43', '::1'),
(154, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:26:19', '::1'),
(155, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 00:27:18', '::1'),
(156, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:27:26', '::1'),
(157, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:39:12', '::1'),
(158, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:48:47', '::1'),
(159, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 00:59:03', '::1'),
(160, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 00:59:04', '::1'),
(161, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 14:29:58', '::1'),
(162, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 14:47:52', '::1'),
(163, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 14:52:20', '::1'),
(164, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 14:52:22', '::1'),
(165, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 15:04:08', '::1'),
(166, 29, 'Actualización de perfil', 'usuarios', 29, '{}', '{\"message\":\"Perfil actualizado exitosamente.\"}', '2025-06-29 15:04:27', '::1'),
(167, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 15:07:04', '::1'),
(168, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 15:07:06', '::1'),
(169, 29, 'Actualización de perfil', 'usuarios', 29, '{}', '{\"message\":\"Perfil actualizado exitosamente.\"}', '2025-06-29 15:20:00', '::1'),
(170, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 15:45:53', '::1'),
(171, 29, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 15:45:54', '::1'),
(172, 29, 'Actualización de perfil', 'usuarios', 29, '{}', '{\"message\":\"Perfil actualizado exitosamente.\"}', '2025-06-29 16:06:18', '::1'),
(173, 29, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 16:25:00', '::1'),
(174, 30, 'Registro de nuevo usuario', 'usuarios', NULL, NULL, '{\"success\":true,\"message\":\"Usuario registrado. Espera aprobación del administrador.\",\"usuario\":{\"id_usuario\":30,\"cedula\":\"2456527\"}}', '2025-06-29 23:19:52', '::1'),
(175, 9, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 23:19:58', '::1'),
(176, 9, 'Asignación de rol a usuario', 'usuarios', NULL, NULL, '{\"message\":\"Usuario asignado y registrado correctamente.\"}', '2025-06-29 23:21:59', '::1'),
(177, 9, 'Logout', NULL, NULL, NULL, NULL, '2025-06-29 23:22:03', '::1'),
(178, 30, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-29 23:22:13', '::1'),
(179, 30, 'Actualización de perfil', 'usuarios', 30, '{}', '{\"message\":\"Perfil actualizado exitosamente.\"}', '2025-06-29 23:37:40', '::1'),
(180, 30, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-06-30 00:27:03', '::1'),
(181, 30, 'Logout', NULL, NULL, NULL, NULL, '2025-06-30 00:42:03', '::1'),
(182, 31, 'Registro de nuevo usuario', 'usuarios', NULL, NULL, '{\"success\":true,\"message\":\"Usuario registrado. Espera aprobación del administrador.\",\"usuario\":{\"id_usuario\":31,\"cedula\":\"156541564\"}}', '2025-07-03 12:58:12', '::1'),
(183, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-07-03 12:58:18', '::1'),
(184, 21, 'Logout', NULL, NULL, NULL, NULL, '2025-07-03 12:59:19', '::1'),
(185, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-07-03 13:06:48', '::1'),
(186, 21, 'Logout', NULL, NULL, NULL, NULL, '2025-07-03 13:44:30', '::1'),
(187, 32, 'Registro de nuevo usuario', 'usuarios', NULL, NULL, '{\"success\":true,\"message\":\"Usuario registrado. Espera aprobación del administrador.\",\"usuario\":{\"id_usuario\":32,\"cedula\":\"45623456\"}}', '2025-07-03 13:45:17', '::1'),
(188, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-07-03 13:45:20', '::1'),
(189, 21, 'Logout', NULL, NULL, NULL, NULL, '2025-07-03 13:45:28', '::1'),
(190, 21, 'Login exitoso', NULL, NULL, NULL, NULL, '2025-07-03 13:47:01', '::1'),
(191, 21, 'Registro de notas por lote', 'notas', NULL, NULL, '{\"message\":\"Notas y comentarios registrados/actualizados correctamente.\"}', '2025-07-03 13:50:10', '::1'),
(192, 21, 'Logout', NULL, NULL, NULL, NULL, '2025-07-03 13:50:52', '::1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materias`
--

CREATE TABLE `materias` (
  `id_materia` int(11) NOT NULL,
  `id_curso` int(11) NOT NULL,
  `materia` varchar(45) NOT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `materias`
--

INSERT INTO `materias` (`id_materia`, `id_curso`, `materia`, `activo`) VALUES
(2, 1, 'Álgebra', 1),
(3, 1, 'Geometría', 1),
(4, 1, 'Cálculo I', 1),
(5, 2, 'Biología', 1),
(6, 2, 'Química', 1),
(7, 2, 'Física', 1),
(8, 3, 'Historia Antigua', 1),
(9, 3, 'Historia Medieval', 1),
(10, 3, 'Historia Contemporánea', 0),
(11, 4, 'Gramática', 1),
(12, 4, 'Ortografía', 0),
(13, 4, 'Literatura Universal', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materias_periodo`
--

CREATE TABLE `materias_periodo` (
  `id_materia_periodo` int(11) NOT NULL,
  `id_materia` int(11) DEFAULT NULL,
  `id_periodo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `materias_periodo`
--

INSERT INTO `materias_periodo` (`id_materia_periodo`, `id_materia`, `id_periodo`) VALUES
(4, 5, 12),
(5, 4, 13),
(8, 7, 12),
(9, 3, 12),
(10, 11, 12),
(11, 8, 13),
(12, 10, 13),
(13, 9, 12),
(14, 13, 13),
(15, 12, 12),
(16, 6, 12),
(18, 2, 13);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materias_seccion`
--

CREATE TABLE `materias_seccion` (
  `id_cursos_materias` int(11) NOT NULL,
  `id_materia` int(11) DEFAULT NULL,
  `id_seccion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `materias_seccion`
--

INSERT INTO `materias_seccion` (`id_cursos_materias`, `id_materia`, `id_seccion`) VALUES
(2, 5, 1),
(3, 4, 1),
(6, 7, 1),
(7, 3, 1),
(8, 11, 1),
(9, 8, 1),
(10, 10, 1),
(11, 9, 1),
(12, 13, 1),
(13, 12, 1),
(14, 6, 1),
(16, 2, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nivel`
--

CREATE TABLE `nivel` (
  `id_nivel` int(11) NOT NULL,
  `tipo_nivel` enum('Administrador','Profesor','Estudiante','pendiente') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `nivel`
--

INSERT INTO `nivel` (`id_nivel`, `tipo_nivel`) VALUES
(1, 'Estudiante'),
(2, 'Administrador'),
(3, 'Profesor'),
(4, 'pendiente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notas`
--

CREATE TABLE `notas` (
  `id_nota` int(11) NOT NULL,
  `id_actividad` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `nota` decimal(5,2) NOT NULL,
  `fecha_registro` date DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `notas`
--

INSERT INTO `notas` (`id_nota`, `id_actividad`, `id_estudiante`, `nota`, `fecha_registro`) VALUES
(42, 15, 18, 15.00, '2025-07-03'),
(43, 15, 1, 12.00, '2025-07-03'),
(44, 15, 29, 9.00, '2025-07-03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id_notificacion` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_admin` int(11) NOT NULL,
  `estado` enum('pendiente','visto','procesado') DEFAULT 'pendiente',
  `mensaje` varchar(255) NOT NULL DEFAULT 'Usuario por confirmación',
  `fecha` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `notificaciones`
--

INSERT INTO `notificaciones` (`id_notificacion`, `id_usuario`, `id_admin`, `estado`, `mensaje`, `fecha`) VALUES
(2, 10, 1, 'procesado', 'Usuario por confirmación', '2025-06-07 00:52:18'),
(3, 11, 1, 'procesado', 'Usuario por confirmación', '2025-06-08 00:45:28'),
(4, 13, 1, 'procesado', 'Usuario por confirmación', '2025-06-08 00:45:06'),
(5, 14, 1, 'procesado', 'Usuario por confirmación', '2025-06-10 01:37:02'),
(6, 15, 1, 'procesado', 'Usuario por confirmación', '2025-06-10 01:42:43'),
(7, 16, 1, 'procesado', 'Usuario por confirmación', '2025-06-10 01:45:42'),
(8, 17, 1, 'procesado', 'Usuario por confirmación', '2025-06-10 19:15:52'),
(9, 18, 1, 'procesado', 'Usuario por confirmación', '2025-06-11 21:26:31'),
(10, 19, 1, 'procesado', 'Usuario por confirmación', '2025-06-17 14:29:56'),
(11, 20, 1, 'procesado', 'Usuario por confirmación', '2025-06-24 20:14:40'),
(12, 21, 1, 'procesado', 'Usuario por confirmación', '2025-06-23 15:05:47'),
(13, 22, 1, 'procesado', 'Usuario por confirmación', '2025-06-24 17:13:21'),
(14, 23, 1, 'procesado', 'Usuario por confirmación', '2025-06-24 20:52:15'),
(15, 24, 1, 'procesado', 'Usuario por confirmación', '2025-06-24 21:49:31'),
(16, 25, 1, 'procesado', 'Usuario por confirmación', '2025-06-24 21:43:16'),
(17, 26, 1, 'procesado', 'Usuario por confirmación', '2025-06-24 21:37:12'),
(18, 27, 1, 'procesado', 'Usuario por confirmación', '2025-06-24 21:41:59'),
(19, 28, 1, 'procesado', 'Usuario por confirmación', '2025-06-24 22:40:22'),
(20, 29, 1, 'procesado', 'Usuario por confirmación', '2025-06-26 15:59:03'),
(21, 30, 1, 'procesado', 'Usuario por confirmación', '2025-06-29 23:22:00'),
(22, 31, 1, 'pendiente', 'Usuario por confirmación', '2025-07-03 12:58:12'),
(23, 32, 1, 'pendiente', 'Usuario por confirmación', '2025-07-03 13:45:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `periodo`
--

CREATE TABLE `periodo` (
  `id_periodo` int(11) NOT NULL,
  `periodo` varchar(45) NOT NULL,
  `fechaInicio` date NOT NULL,
  `fechaFinal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `periodo`
--

INSERT INTO `periodo` (`id_periodo`, `periodo`, `fechaInicio`, `fechaFinal`) VALUES
(12, '2025-2026', '2025-07-04', '2026-03-19'),
(13, '2026-2027', '2026-03-30', '2027-01-07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesores`
--

CREATE TABLE `profesores` (
  `id_profesor` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `profesores`
--

INSERT INTO `profesores` (`id_profesor`, `id_usuario`) VALUES
(17, 17),
(19, 19);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seccion`
--

CREATE TABLE `seccion` (
  `id_seccion` int(11) NOT NULL,
  `seccion` varchar(45) NOT NULL,
  `estado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `seccion`
--

INSERT INTO `seccion` (`id_seccion`, `seccion`, `estado`) VALUES
(1, 'C', 1),
(2, 'B', 0),
(3, 'A', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `id_nivel` int(11) NOT NULL,
  `id_direccion` int(11) NOT NULL,
  `cedula` varchar(20) NOT NULL,
  `primer_nombre` varchar(85) NOT NULL,
  `segundo_nombre` varchar(45) NOT NULL,
  `primer_apellido` varchar(45) NOT NULL,
  `segundo_apellido` varchar(45) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(60) DEFAULT NULL,
  `contraseña` varchar(60) DEFAULT NULL,
  `rol` enum('admin','estudiante','profesor','pendiente') NOT NULL,
  `estado` tinyint(1) DEFAULT 1,
  `ultima_conexion` datetime DEFAULT NULL,
  `profile_icon_class` varchar(50) DEFAULT 'bx bx-user-circle'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `id_nivel`, `id_direccion`, `cedula`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `telefono`, `correo`, `contraseña`, `rol`, `estado`, `ultima_conexion`, `profile_icon_class`) VALUES
(1, 1, 17, '1234', 'María', 'Alejandra', 'González', 'Pérez', '0412-1234567', 'maria.gonzalez@gmail.com', '1', 'estudiante', 1, '2025-06-06 18:08:07', 'bx bx-user-circle'),
(6, 4, 6, '245652', 'Carlos', 'Andrés', 'López', 'García', '0412-1234567', 'carlos.lopez@gmail.com', NULL, 'pendiente', 1, NULL, 'bx bx-user-circle'),
(7, 4, 7, '12345789', 'Ana', 'Sofía', 'Martínez', 'Rodríguez', '0412-1234567', 'ana.martinez@gmail.com', NULL, 'pendiente', 1, NULL, 'bx bx-user-circle'),
(8, 4, 8, '245657', 'Juan', 'Pablo', 'Sánchez', 'Hernández', '0412-1234567', 'juan.sanchez@gmail.com', '$2b$10$b83IfLy3Rcu.ommMdO8VVOrIGVKHs9cgLgMfhxOvXDdjq/.oxh.qq', 'pendiente', 1, '2025-06-26 23:48:06', 'bx bx-user-circle'),
(9, 2, 6, '123456789', 'Laura', 'Isabel', 'Ramírez', 'Díaz', '0412-1234567', 'laura.ramirez@gmail.com', '$2b$10$Q5MJY2KY/zpVZhOotsxu..8nPsqXztZuijTqb3SGVSGgb8TJEA4.e', 'admin', 1, '2025-06-29 23:19:58', 'bx bx-user-circle'),
(10, 2, 10, '1234578', 'Pedro', 'Antonio', 'Gómez', 'Fernández', '0412-4565454', 'pedro.gomez@gmail.com', '$2b$10$NaKd.ifu0i4.xTtn1w5v6uqUAr3Y4jOr06IsZEi6NZmlvxdBH77iG', 'profesor', 1, NULL, 'bx bx-user-circle'),
(11, 1, 11, '1230785', 'Luisa', 'Fernanda', 'Torres', 'Vargas', '0412-1234567', 'luisa.torres@gmail.com', '$2b$10$PMpTs.g8HNedR/ceFqQyCe9qHAPCtaiius9vhPufaIc07/P2VBqDO', 'estudiante', 1, '2025-06-28 23:36:08', 'bx bx-user-circle'),
(12, 1, 12, '45654221', 'Diego', 'Alejandro', 'Silva', 'Mendoza', '0422-1234567', 'diego.silva@gmail.com', NULL, 'estudiante', 0, NULL, 'bx bx-user-circle'),
(13, 1, 13, '123475', 'Valentina', 'Carolina', 'Rojas', 'Castillo', '0412-1234567', 'valentina.rojas@gmail.com', '$2b$10$hZwkptOyaa26g/mLSZOkBe15zmwLalOhSka/Ln0abQjrjEXBcbEX.', 'estudiante', 1, '2025-06-22 19:09:05', 'bx bx-user-circle'),
(14, 3, 18, '123445', 'Ricardo', 'José', 'Mendoza', 'Paredes', '0412-4532131', 'ricardo.mendoza@gmail.com', '$2b$10$wKCIqjkT58YmD/E6w7QI5urZsxQPZSQgESuSh5cA1ZIiMlBjYpxX6', 'profesor', 1, '2025-06-29 00:12:39', 'bx bx-user-circle'),
(15, 3, 19, '45645654', 'Gabriela', 'María', 'Castro', 'Ríos', '0414-4554254', 'gabriela.castro@gmail.com', '$2b$10$06KiPvjr.G27frDwsMDtte4nWRVAEmi6Sc8Zp5TL5Fw2WKYhqHc.u', 'profesor', 1, '2025-06-17 03:05:27', 'bx bx-user-circle'),
(16, 3, 20, '45654545', 'José', 'Luis', 'Fernández', 'Morales', '0412-4565454', 'jose.fernandez@gmail.com', '$2b$10$wLq0RnEV.2mH.RIredTJb.ot0y3VZoXi0boKmkIgJBnlrCCWNXxe6', 'profesor', 0, NULL, 'bx bx-user-circle'),
(17, 3, 21, '23456464', 'Carmen', 'Rosa', 'Gutiérrez', 'Vega', '0412-4564554', 'carmen.gutierrez@gmail.com', '$2b$10$goLVsCFbNm81Klg4YQt5VuXsWfoFK7.GF2dfJH98jiGDaDx2CguqW', 'profesor', 1, '2025-06-23 19:28:26', 'bx bx-user-circle'),
(18, 1, 22, '234234', 'Alejandro', 'Manuel', 'Díaz', 'Cordero', '0412-1234567', 'alejandro.diaz@gmail.com', '$2b$10$OOfknBGkYbNN9pHbQmreOOdNT/YpVIu2/v5NWwT3.USrsoUb07Ckm', 'estudiante', 1, '2025-06-26 23:47:49', 'bx bx-user-circle'),
(19, 3, 23, '2456522', 'Isabel', 'Cristina', 'Pérez', 'Rojas', '0412-1234567', 'isabel.perez@gmail.com', '$2b$10$Aza7P6TeCXNrRujosgLB3.A9ct61sO1mdKaraR4sY.05mBRe8pFuy', 'profesor', 1, '2025-06-29 00:20:00', 'bx bx-user-circle'),
(20, 2, 24, '45456456', 'Roberto', 'Carlos', 'Vargas', 'Mendoza', '0412-1231231', 'roberto.vargas@gmail.com', '$2b$10$Aui7uuIiSfT5Jp6PfuSJo.ZCRE.IMWp5BFKToxQ0YGL3QnlZdoZri', 'admin', 1, '2025-06-18 22:35:52', 'bx bx-user-circle'),
(21, 2, 25, '30325075', 'ruth', 'daniela', 'oropeza', 'garcia', '0414-5458943', 'ruthoropeza30@gmail.com', '$2b$10$M.5R..LQsyh9F0241j5SBOVNCXe5rr3JVN6kYLO7.bAgMtG2KuX8m', 'admin', 1, '2025-07-03 13:47:01', 'bx bx-user-circle'),
(22, 1, 26, '987654321', 'Patricia', 'Lucía', 'Suárez', 'López', '0412-5896345', 'patricia.suarez@gmail.com', '$2b$10$3US6lxhOpLcAtYdFEMScI.FwIqnDYTO8ixqfAtzaU3I.G4J8EBo56', 'estudiante', 1, '2025-06-23 18:27:22', 'bx bx-user-circle'),
(23, 1, 27, '12124545', 'Francisco', 'Javier', 'Mora', 'Salazar', '0412-7894563', 'francisco.mora@gmail.com', '$2b$10$hfJ./GpynTlUMVawWVbdWOPMXLHdVaYaGpi/nnnf8lTyGzZRUTmEm', 'estudiante', 1, NULL, 'bx bx-user-circle'),
(24, 2, 28, '111111', 'Sandra', 'Marcela', 'Ríos', 'Blanco', '0412-1234567', 'sandra.rios@gmail.com', '$2b$10$qBoWfab/GyUnbE4.LuVqYelK.dhu0ovTuWJq7B0bxKJ/vpFWTkawW', 'admin', 1, NULL, 'bx bx-user-circle'),
(25, 1, 29, '1232131', 'Jose', 'Jose', 'Perez', 'Lopez', '0412-4565454', 'jose123@gmail.com.com', '$2b$10$c6wV21EF0c.W6QPHKyVhWuK0HDBwYAbh2baoxhB2Lt2wtNVd/wkFO', 'estudiante', 1, NULL, 'bx bx-user-circle'),
(26, 2, 30, '122111', 'Miguel', 'Ángel', 'Castro', 'Romero', '0412-1234567', 'miguel.castro@gmail.com', '$2b$10$0EqEp8Prpsdm0jtXfTSP6e1Lfx0rDm7poRxaGrbarzRLX3msFpZqe', 'admin', 1, NULL, 'bx bx-user-circle'),
(27, 2, 31, '2456524', 'Daniela', 'Fernanda', 'Herrera', 'Navarro', '0412-1234567', 'daniela.herrera@gmail.com', '$2b$10$LYZ16cv48CBg6o9s1XWZOeVJe7G.xNoDVp/TIzi2ABulrfS9rtZOa', 'admin', 1, NULL, 'bx bx-user-circle'),
(28, 2, 32, '1231211', 'Jorge', 'Alberto', 'Silva', 'Fuentes', '0412-1234567', 'jorge.silva@gmail.com', '$2b$10$6Dm0Cx1WZORrjLWI38WdJuFj4rddA2mniSNVQiKM2oRxXwSHy6vnu', 'admin', 1, NULL, 'bx bx-user-circle'),
(29, 1, 33, '28539837', 'Andis', 'Gs', 'Lopez', 'gh', '0412-1234567', 'andislopez123@gmail.com', '$2b$10$VDG6IycLozYlulhwkHTg3OZ62jtZCqwbPES7iyJYyrIL2bL9XrNpW', 'estudiante', 1, '2025-06-29 15:45:54', 'bx bxs-zap'),
(30, 1, 34, '2456527', 'Andrea', 'Carolina', 'Méndez', 'Guerrero', '0422-1234567', 'andrea.mendez@gmail.com', '$2b$10$PzHxv3706Un0Ce7jzhFfN.gzGV/vYADfQTU1d2Fi.0pnUZmGF9hju', 'estudiante', 1, '2025-06-30 00:27:03', 'bx bx-bulb'),
(31, 4, 35, '156541564', 'Luis', 'Enrique', 'Rojas', 'Paredes', '0412-5465464', 'luis.rojas@gmail.com', '$2b$10$2SwF9i8VBmcovMu6fVMnIewIrqipjwYu069ZtTY3SwB4fiHN6eKw6', 'pendiente', 1, NULL, 'bx bx-user-circle'),
(32, 4, 36, '45623456', 'Luis', 'Fernando', 'Fernandez', 'Caripa', '0412-5465456', 'caripa@gmail.com', '$2b$10$AxGyGnqQKI4sZIAnFpID8eo6UeVTIXgXl1j.7ywVmotT44H2gJH0i', 'pendiente', 1, NULL, 'bx bx-user-circle');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_administradores`
--

CREATE TABLE `usuario_administradores` (
  `id_admin` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `usuario_administradores`
--

INSERT INTO `usuario_administradores` (`id_admin`, `id_usuario`) VALUES
(1, 9),
(20, 20),
(21, 24),
(22, 28);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_cursos`
--

CREATE TABLE `usuario_cursos` (
  `id_usuario_cursos` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_curso` int(11) NOT NULL,
  `fecha_inscripcion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `usuario_cursos`
--

INSERT INTO `usuario_cursos` (`id_usuario_cursos`, `id_usuario`, `id_curso`, `fecha_inscripcion`) VALUES
(2, 10, 1, '2025-06-07 00:52:18'),
(5, 11, 2, '2025-06-08 00:45:28'),
(20, 13, 3, '2025-06-14 23:08:54'),
(22, 12, 3, '2025-06-14 22:28:33'),
(37, 14, 2, '2025-06-14 23:33:02'),
(38, 15, 1, '2025-06-14 23:40:18'),
(39, 16, 3, '2025-06-10 05:45:42'),
(40, 17, 2, '2025-06-10 23:15:52'),
(41, 18, 3, '2025-06-14 22:57:12'),
(42, 1, 2, '2025-06-14 22:21:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_materias`
--

CREATE TABLE `usuario_materias` (
  `id_usuario_materias` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_materia` int(11) NOT NULL,
  `id_periodo` int(11) NOT NULL,
  `fecha_inscripcion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `usuario_materias`
--

INSERT INTO `usuario_materias` (`id_usuario_materias`, `id_usuario`, `id_materia`, `id_periodo`, `fecha_inscripcion`) VALUES
(20, 18, 13, 13, '2025-07-03 13:49:02'),
(21, 1, 13, 13, '2025-07-03 13:49:02'),
(22, 29, 13, 13, '2025-07-03 13:49:02'),
(23, 15, 13, 13, '2025-07-03 13:49:28');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_periodo`
--

CREATE TABLE `usuario_periodo` (
  `id_usuario_periodo` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_periodo` int(11) NOT NULL,
  `fecha_inscripcion` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario_periodo`
--

INSERT INTO `usuario_periodo` (`id_usuario_periodo`, `id_usuario`, `id_periodo`, `fecha_inscripcion`) VALUES
(2, 11, 12, '0000-00-00'),
(4, 13, 12, '2025-06-08'),
(6, 12, 13, '2025-06-08'),
(15, 1, 12, '2025-06-14'),
(16, 18, 12, '2025-06-14'),
(17, 14, 12, '2025-06-14'),
(18, 16, 13, '2025-06-14'),
(19, 15, 13, '2025-06-14'),
(20, 23, 13, '2025-06-24'),
(21, 25, 12, '2025-06-24'),
(22, 29, 13, '2025-06-26'),
(23, 30, 12, '2025-06-29'),
(24, 22, 12, '2025-07-03'),
(25, 10, 12, '2025-07-10'),
(26, 14, 12, '2025-07-11'),
(27, 17, 12, '2025-07-12'),
(28, 15, 13, '2025-07-13'),
(29, 16, 13, '2025-07-14'),
(30, 19, 13, '2025-07-15');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_seccion`
--

CREATE TABLE `usuario_seccion` (
  `id_usuario` int(11) NOT NULL,
  `id_usuario_seccion` int(11) NOT NULL,
  `id_seccion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario_seccion`
--

INSERT INTO `usuario_seccion` (`id_usuario`, `id_usuario_seccion`, `id_seccion`) VALUES
(10, 2, 1),
(11, 5, 1),
(13, 6, 1),
(12, 8, 1),
(14, 17, 1),
(15, 18, 1),
(15, 19, 1),
(16, 20, 1),
(17, 21, 1),
(18, 22, 1),
(1, 23, 1),
(19, 24, 1),
(21, 25, 1),
(22, 26, 1),
(23, 27, 2),
(25, 28, 1),
(29, 29, 1),
(30, 30, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `actividades`
--
ALTER TABLE `actividades`
  ADD PRIMARY KEY (`id_actividad`),
  ADD KEY `fk_actividades_materia` (`id_materia`),
  ADD KEY `id_periodo` (`id_periodo`);

--
-- Indices de la tabla `ciudades`
--
ALTER TABLE `ciudades`
  ADD PRIMARY KEY (`id_ciudad`),
  ADD KEY `id_estado` (`id_estado`);

--
-- Indices de la tabla `codigos_recuperacion`
--
ALTER TABLE `codigos_recuperacion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `correo` (`correo`);

--
-- Indices de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD PRIMARY KEY (`id_comentario`),
  ADD KEY `id_estudiante` (`id_estudiante`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_actividad` (`id_actividad`);

--
-- Indices de la tabla `cursos`
--
ALTER TABLE `cursos`
  ADD PRIMARY KEY (`id_curso`);

--
-- Indices de la tabla `cursos_materias`
--
ALTER TABLE `cursos_materias`
  ADD PRIMARY KEY (`id_curso_materia`),
  ADD KEY `id_estudiante` (`id_estudiante`),
  ADD KEY `id_curso` (`id_curso`),
  ADD KEY `id_materia` (`id_materia`),
  ADD KEY `id_periodo` (`id_periodo`),
  ADD KEY `id_nota` (`id_nota`);

--
-- Indices de la tabla `cursos_periodo`
--
ALTER TABLE `cursos_periodo`
  ADD PRIMARY KEY (`id_curso_periodo`),
  ADD KEY `id_curso` (`id_curso`),
  ADD KEY `id_periodo` (`id_periodo`);

--
-- Indices de la tabla `cursos_seccion`
--
ALTER TABLE `cursos_seccion`
  ADD PRIMARY KEY (`id_cursos_seccion`),
  ADD KEY `id_curso` (`id_curso`),
  ADD KEY `id_seccion` (`id_seccion`);

--
-- Indices de la tabla `direccion`
--
ALTER TABLE `direccion`
  ADD PRIMARY KEY (`id_direccion`),
  ADD KEY `id_ciudad` (`id_ciudad`),
  ADD KEY `id_estado` (`id_estado`);

--
-- Indices de la tabla `estados`
--
ALTER TABLE `estados`
  ADD PRIMARY KEY (`id_estado`);

--
-- Indices de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD PRIMARY KEY (`id_estudiante`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `historial_acciones`
--
ALTER TABLE `historial_acciones`
  ADD PRIMARY KEY (`id_historial`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `materias`
--
ALTER TABLE `materias`
  ADD PRIMARY KEY (`id_materia`),
  ADD KEY `id_curso` (`id_curso`);

--
-- Indices de la tabla `materias_periodo`
--
ALTER TABLE `materias_periodo`
  ADD PRIMARY KEY (`id_materia_periodo`),
  ADD KEY `id_materia` (`id_materia`),
  ADD KEY `id_periodo` (`id_periodo`);

--
-- Indices de la tabla `materias_seccion`
--
ALTER TABLE `materias_seccion`
  ADD PRIMARY KEY (`id_cursos_materias`),
  ADD KEY `id_materia` (`id_materia`),
  ADD KEY `id_seccion` (`id_seccion`);

--
-- Indices de la tabla `nivel`
--
ALTER TABLE `nivel`
  ADD PRIMARY KEY (`id_nivel`);

--
-- Indices de la tabla `notas`
--
ALTER TABLE `notas`
  ADD PRIMARY KEY (`id_nota`),
  ADD KEY `id_actividad` (`id_actividad`),
  ADD KEY `id_estudiante` (`id_estudiante`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id_notificacion`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_admin` (`id_admin`);

--
-- Indices de la tabla `periodo`
--
ALTER TABLE `periodo`
  ADD PRIMARY KEY (`id_periodo`);

--
-- Indices de la tabla `profesores`
--
ALTER TABLE `profesores`
  ADD PRIMARY KEY (`id_profesor`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `seccion`
--
ALTER TABLE `seccion`
  ADD PRIMARY KEY (`id_seccion`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `id_nivel` (`id_nivel`),
  ADD KEY `id_direccion` (`id_direccion`);

--
-- Indices de la tabla `usuario_administradores`
--
ALTER TABLE `usuario_administradores`
  ADD PRIMARY KEY (`id_admin`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `usuario_cursos`
--
ALTER TABLE `usuario_cursos`
  ADD PRIMARY KEY (`id_usuario_cursos`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_curso` (`id_curso`);

--
-- Indices de la tabla `usuario_materias`
--
ALTER TABLE `usuario_materias`
  ADD PRIMARY KEY (`id_usuario_materias`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_materia` (`id_materia`),
  ADD KEY `id_periodo` (`id_periodo`);

--
-- Indices de la tabla `usuario_periodo`
--
ALTER TABLE `usuario_periodo`
  ADD PRIMARY KEY (`id_usuario_periodo`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_periodo` (`id_periodo`);

--
-- Indices de la tabla `usuario_seccion`
--
ALTER TABLE `usuario_seccion`
  ADD PRIMARY KEY (`id_usuario_seccion`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_seccion` (`id_seccion`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `actividades`
--
ALTER TABLE `actividades`
  MODIFY `id_actividad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `codigos_recuperacion`
--
ALTER TABLE `codigos_recuperacion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  MODIFY `id_comentario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `cursos`
--
ALTER TABLE `cursos`
  MODIFY `id_curso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `cursos_materias`
--
ALTER TABLE `cursos_materias`
  MODIFY `id_curso_materia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `cursos_periodo`
--
ALTER TABLE `cursos_periodo`
  MODIFY `id_curso_periodo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `cursos_seccion`
--
ALTER TABLE `cursos_seccion`
  MODIFY `id_cursos_seccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `direccion`
--
ALTER TABLE `direccion`
  MODIFY `id_direccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `estados`
--
ALTER TABLE `estados`
  MODIFY `id_estado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  MODIFY `id_estudiante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `historial_acciones`
--
ALTER TABLE `historial_acciones`
  MODIFY `id_historial` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=193;

--
-- AUTO_INCREMENT de la tabla `materias`
--
ALTER TABLE `materias`
  MODIFY `id_materia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `materias_periodo`
--
ALTER TABLE `materias_periodo`
  MODIFY `id_materia_periodo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `materias_seccion`
--
ALTER TABLE `materias_seccion`
  MODIFY `id_cursos_materias` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `nivel`
--
ALTER TABLE `nivel`
  MODIFY `id_nivel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `notas`
--
ALTER TABLE `notas`
  MODIFY `id_nota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id_notificacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `periodo`
--
ALTER TABLE `periodo`
  MODIFY `id_periodo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `profesores`
--
ALTER TABLE `profesores`
  MODIFY `id_profesor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `seccion`
--
ALTER TABLE `seccion`
  MODIFY `id_seccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `usuario_administradores`
--
ALTER TABLE `usuario_administradores`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `usuario_cursos`
--
ALTER TABLE `usuario_cursos`
  MODIFY `id_usuario_cursos` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT de la tabla `usuario_materias`
--
ALTER TABLE `usuario_materias`
  MODIFY `id_usuario_materias` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `usuario_periodo`
--
ALTER TABLE `usuario_periodo`
  MODIFY `id_usuario_periodo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `usuario_seccion`
--
ALTER TABLE `usuario_seccion`
  MODIFY `id_usuario_seccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `actividades`
--
ALTER TABLE `actividades`
  ADD CONSTRAINT `actividades_ibfk_1` FOREIGN KEY (`id_periodo`) REFERENCES `periodo` (`id_periodo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_actividades_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ciudades`
--
ALTER TABLE `ciudades`
  ADD CONSTRAINT `ciudades_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD CONSTRAINT `comentarios_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE,
  ADD CONSTRAINT `comentarios_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `comentarios_ibfk_3` FOREIGN KEY (`id_actividad`) REFERENCES `actividades` (`id_actividad`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_comentarios_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cursos_materias`
--
ALTER TABLE `cursos_materias`
  ADD CONSTRAINT `cursos_materias_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cursos_materias_ibfk_2` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cursos_materias_ibfk_3` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cursos_materias_ibfk_4` FOREIGN KEY (`id_periodo`) REFERENCES `periodo` (`id_periodo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cursos_materias_ibfk_5` FOREIGN KEY (`id_nota`) REFERENCES `notas` (`id_nota`);

--
-- Filtros para la tabla `cursos_periodo`
--
ALTER TABLE `cursos_periodo`
  ADD CONSTRAINT `cursos_periodo_ibfk_1` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cursos_periodo_ibfk_2` FOREIGN KEY (`id_periodo`) REFERENCES `periodo` (`id_periodo`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `cursos_seccion`
--
ALTER TABLE `cursos_seccion`
  ADD CONSTRAINT `cursos_seccion_ibfk_1` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cursos_seccion_ibfk_2` FOREIGN KEY (`id_seccion`) REFERENCES `seccion` (`id_seccion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `direccion`
--
ALTER TABLE `direccion`
  ADD CONSTRAINT `direccion_ibfk_1` FOREIGN KEY (`id_ciudad`) REFERENCES `ciudades` (`id_ciudad`) ON UPDATE CASCADE,
  ADD CONSTRAINT `direccion_ibfk_2` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD CONSTRAINT `estudiantes_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `historial_acciones`
--
ALTER TABLE `historial_acciones`
  ADD CONSTRAINT `historial_acciones_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `materias`
--
ALTER TABLE `materias`
  ADD CONSTRAINT `materias_ibfk_1` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `materias_periodo`
--
ALTER TABLE `materias_periodo`
  ADD CONSTRAINT `materias_periodo_ibfk_1` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `materias_periodo_ibfk_2` FOREIGN KEY (`id_periodo`) REFERENCES `periodo` (`id_periodo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `materias_seccion`
--
ALTER TABLE `materias_seccion`
  ADD CONSTRAINT `materias_seccion_ibfk_1` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `materias_seccion_ibfk_2` FOREIGN KEY (`id_seccion`) REFERENCES `seccion` (`id_seccion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `notas`
--
ALTER TABLE `notas`
  ADD CONSTRAINT `notas_ibfk_1` FOREIGN KEY (`id_actividad`) REFERENCES `actividades` (`id_actividad`) ON UPDATE CASCADE,
  ADD CONSTRAINT `notas_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `usuario_administradores` (`id_admin`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_nivel`) REFERENCES `nivel` (`id_nivel`) ON UPDATE CASCADE,
  ADD CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`id_direccion`) REFERENCES `direccion` (`id_direccion`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario_administradores`
--
ALTER TABLE `usuario_administradores`
  ADD CONSTRAINT `usuario_administradores_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario_cursos`
--
ALTER TABLE `usuario_cursos`
  ADD CONSTRAINT `usuario_cursos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuario_cursos_ibfk_2` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario_materias`
--
ALTER TABLE `usuario_materias`
  ADD CONSTRAINT `usuario_materias_ibfk_1` FOREIGN KEY (`id_periodo`) REFERENCES `periodo` (`id_periodo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuario_materias_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuario_materias_ibfk_3` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario_periodo`
--
ALTER TABLE `usuario_periodo`
  ADD CONSTRAINT `usuario_periodo_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuario_periodo_ibfk_2` FOREIGN KEY (`id_periodo`) REFERENCES `periodo` (`id_periodo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario_seccion`
--
ALTER TABLE `usuario_seccion`
  ADD CONSTRAINT `usuario_seccion_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuario_seccion_ibfk_2` FOREIGN KEY (`id_seccion`) REFERENCES `seccion` (`id_seccion`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
