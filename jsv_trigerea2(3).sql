-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: May 21, 2025 at 11:51 AM
-- Server version: 9.3.0
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jsv_trigerea2`
--

-- --------------------------------------------------------

--
-- Table structure for table `jsv_categorias`
--

CREATE TABLE `jsv_categorias` (
  `idCategoria` int NOT NULL,
  `categoria` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jsv_categorias`
--

INSERT INTO `jsv_categorias` (`idCategoria`, `categoria`) VALUES
(1, 'LACTEOS'),
(2, 'CARNES'),
(3, 'PESCADOS');

--
-- Triggers `jsv_categorias`
--
DELIMITER $$
CREATE TRIGGER `jsv_eliminar_productosyventas_relacionados` BEFORE DELETE ON `jsv_categorias` FOR EACH ROW BEGIN

-- Eliminamos los productos relacionados
	DELETE
    FROM jsv_pvp WHERE idProducto IN (
     SELECT idProducto FROM jsv_producto WHERE idCategoria=old.idCategoria);


-- Eliminamos las ventas relacionadas
	DELETE 
    FROM jsv_producto 
    WHERE jsv_producto.idCategoria = old.idCategoria;

    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `jsv_producto`
--

CREATE TABLE `jsv_producto` (
  `idProducto` int NOT NULL,
  `idCategoria` int NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `stock` int NOT NULL,
  `precio_compra` double(6,2) NOT NULL,
  `fecha_compra` date NOT NULL,
  `idProveedor` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jsv_producto`
--

INSERT INTO `jsv_producto` (`idProducto`, `idCategoria`, `nombre`, `stock`, `precio_compra`, `fecha_compra`, `idProveedor`) VALUES
(1, 1, 'Lechesita', 111, 2.00, '2025-05-16', 1),
(12, 1, 'yogur', 23, 3.00, '2025-05-17', 3),
(13, 1, 'Queso', 432, 43.00, '2025-05-13', 4),
(14, 2, 'Ternera', 56, 34.00, '2025-05-14', 2),
(15, 2, 'Bacon', 76, 43.00, '2025-05-09', 5),
(16, 3, 'caballa', 98, 3.00, '2025-05-09', 1),
(17, 3, 'Salmon', 6, 65.00, '2025-05-01', 5),
(18, 3, 'Sardinas', 145, 1.00, '2025-05-02', 3),
(19, 1, 'Quesitos', 9, 8.00, '2025-05-10', 2),
(20, 1, 'Natillas', 90, 1.20, '2025-05-17', 5),
(21, 2, 'Humana', 1, 69.00, '2025-05-20', 5),
(22, 1, 'wert', 23, 2.00, '2025-05-15', 3),
(23, 3, 'qwwe', 21, 214.00, '2025-05-24', 2),
(24, 2, 'popo', 444, 56.00, '2025-05-16', 4),
(25, 3, 'yui', 5, 46.90, '2025-05-02', 1),
(26, 3, 'ret', 23, 12.00, '2025-05-09', 1),
(28, 2, 'wr', 21, 12.00, '2025-05-20', 5);

--
-- Triggers `jsv_producto`
--
DELIMITER $$
CREATE TRIGGER `jsv_eliminar_depvp` BEFORE DELETE ON `jsv_producto` FOR EACH ROW BEGIN

DELETE FROM jsv_pvp WHERE idProducto = old.idProducto;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `jsv_info_paraPVP` AFTER INSERT ON `jsv_producto` FOR EACH ROW BEGIN
-- Incluimos el producto en la tabla pvp 
	DECLARE preciovender double;
	DECLARE caducidad DATE;
    
    SET caducidad = (new.fecha_compra + INTERVAL 30 DAY);
	IF new.idCategoria = '1' 
    	THEN
		SET preciovender = new.precio_compra*1.21*1.3;
	ELSEIF new.idCategoria = '2' 
    	THEN
		SET preciovender = new.precio_compra*1.10*1.3;
	ELSEIF new.idCategoria = '3'
    	THEN
		SET preciovender = new.precio_compra*1.3;
        
END IF;
        
	INSERT INTO jsv_pvp(idProducto, nombre, precio_venta, fecha_caducidad)
	VALUES (new.idProducto, new.nombre, preciovender, caducidad);
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `jsv_proveedores`
--

CREATE TABLE `jsv_proveedores` (
  `idProveedor` int NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jsv_proveedores`
--

INSERT INTO `jsv_proveedores` (`idProveedor`, `nombre`) VALUES
(1, 'Joselito'),
(2, 'Mario'),
(3, 'Francisco'),
(4, 'Adolfo'),
(5, 'Joseph');

-- --------------------------------------------------------

--
-- Table structure for table `jsv_pvp`
--

CREATE TABLE `jsv_pvp` (
  `idProducto` int NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `precio_venta` double(6,2) NOT NULL,
  `fecha_caducidad` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jsv_pvp`
--

INSERT INTO `jsv_pvp` (`idProducto`, `nombre`, `precio_venta`, `fecha_caducidad`) VALUES
(22, 'wert', 3.15, '2025-06-14'),
(23, 'qwwe', 278.20, '2025-06-23'),
(24, 'popo', 80.08, '2025-06-15'),
(25, 'yui', 60.97, '2025-06-01'),
(26, 'ret', 15.60, '2025-06-08'),
(28, 'wr', 17.16, '2025-06-19');

-- --------------------------------------------------------

--
-- Table structure for table `jsv_ventas`
--

CREATE TABLE `jsv_ventas` (
  `idVenta` int NOT NULL,
  `idProducto` int DEFAULT NULL,
  `unidades` int NOT NULL,
  `importe` double NOT NULL,
  `fecha_venta` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jsv_ventas`
--

INSERT INTO `jsv_ventas` (`idVenta`, `idProducto`, `unidades`, `importe`, `fecha_venta`) VALUES
(6, 24, 235, 2, '2025-05-30');

--
-- Triggers `jsv_ventas`
--
DELIMITER $$
CREATE TRIGGER `jsv_stockactualizar` AFTER INSERT ON `jsv_ventas` FOR EACH ROW BEGIN
UPDATE jsv_producto 
SET stock = stock - new.unidades
WHERE idProducto=new.idProducto;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jsv_categorias`
--
ALTER TABLE `jsv_categorias`
  ADD PRIMARY KEY (`idCategoria`);

--
-- Indexes for table `jsv_producto`
--
ALTER TABLE `jsv_producto`
  ADD PRIMARY KEY (`idProducto`),
  ADD KEY `categorias` (`idCategoria`),
  ADD KEY `proveedores` (`idProveedor`);

--
-- Indexes for table `jsv_proveedores`
--
ALTER TABLE `jsv_proveedores`
  ADD PRIMARY KEY (`idProveedor`);

--
-- Indexes for table `jsv_pvp`
--
ALTER TABLE `jsv_pvp`
  ADD PRIMARY KEY (`idProducto`);

--
-- Indexes for table `jsv_ventas`
--
ALTER TABLE `jsv_ventas`
  ADD PRIMARY KEY (`idVenta`),
  ADD KEY `productos` (`idProducto`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jsv_categorias`
--
ALTER TABLE `jsv_categorias`
  MODIFY `idCategoria` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `jsv_producto`
--
ALTER TABLE `jsv_producto`
  MODIFY `idProducto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `jsv_proveedores`
--
ALTER TABLE `jsv_proveedores`
  MODIFY `idProveedor` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `jsv_ventas`
--
ALTER TABLE `jsv_ventas`
  MODIFY `idVenta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `jsv_producto`
--
ALTER TABLE `jsv_producto`
  ADD CONSTRAINT `categorias` FOREIGN KEY (`idCategoria`) REFERENCES `jsv_categorias` (`idCategoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `proveedores` FOREIGN KEY (`idProveedor`) REFERENCES `jsv_proveedores` (`idProveedor`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `jsv_ventas`
--
ALTER TABLE `jsv_ventas`
  ADD CONSTRAINT `productos` FOREIGN KEY (`idProducto`) REFERENCES `jsv_pvp` (`idProducto`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
