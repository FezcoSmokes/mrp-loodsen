-- --------------------------------------------------------
-- Host:                         162.19.139.137
-- Server versie:                10.6.8-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Versie:              11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Structuur van  tabel s30339_fezco.fezco_drugslab wordt geschreven
CREATE TABLE IF NOT EXISTS `fezco_drugslab` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) NOT NULL DEFAULT '0',
  `drugs_type` varchar(50) NOT NULL DEFAULT '',
  `drugs_name` varchar(255) NOT NULL DEFAULT '',
  `drugs_coords` longtext DEFAULT NULL,
  `upgrades` int(11) DEFAULT 0,
  `secondusers` longtext DEFAULT NULL,
  `itemlimits` int(11) DEFAULT 0,
  `coordsforblip` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel s30339_fezco.fezco_drugslab: ~2 rows (ongeveer)
/*!40000 ALTER TABLE `fezco_drugslab` DISABLE KEYS */;
/*!40000 ALTER TABLE `fezco_drugslab` ENABLE KEYS */;

-- Structuur van  tabel s30339_fezco.fezco_drugslab_loodsen wordt geschreven
CREATE TABLE IF NOT EXISTS `fezco_drugslab_loodsen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `drugs_coords` varchar(50) NOT NULL DEFAULT '0',
  `drugs_type` longtext NOT NULL,
  `buyed` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel s30339_fezco.fezco_drugslab_loodsen: ~2 rows (ongeveer)
/*!40000 ALTER TABLE `fezco_drugslab_loodsen` DISABLE KEYS */;
/*!40000 ALTER TABLE `fezco_drugslab_loodsen` ENABLE KEYS */;

-- Structuur van  tabel s30339_fezco.fezco_drugs_items wordt geschreven
CREATE TABLE IF NOT EXISTS `fezco_drugs_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) NOT NULL DEFAULT '0',
  `drugs_name` varchar(50) DEFAULT NULL,
  `drugs_coords` varchar(50) NOT NULL DEFAULT '',
  `drugs_soort` varchar(50) NOT NULL DEFAULT '',
  `item` varchar(50) NOT NULL DEFAULT '',
  `itemlimits` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel s30339_fezco.fezco_drugs_items: ~1 rows (ongeveer)
/*!40000 ALTER TABLE `fezco_drugs_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `fezco_drugs_items` ENABLE KEYS */;

-- Structuur van  tabel s30339_fezco.fezco_drugs_verwerkteitems wordt geschreven
CREATE TABLE IF NOT EXISTS `fezco_drugs_verwerkteitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) NOT NULL DEFAULT '0',
  `drugs_name` varchar(50) DEFAULT NULL,
  `drugs_coords` varchar(50) NOT NULL DEFAULT '',
  `item` varchar(50) NOT NULL DEFAULT '',
  `itemcount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel s30339_fezco.fezco_drugs_verwerkteitems: ~0 rows (ongeveer)
/*!40000 ALTER TABLE `fezco_drugs_verwerkteitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `fezco_drugs_verwerkteitems` ENABLE KEYS */;

-- Structuur van  tabel s30339_fezco.fezco_loodsenopslag_weapons wordt geschreven
CREATE TABLE IF NOT EXISTS `fezco_loodsenopslag_weapons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `drugsloods_coords` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `drugsloods_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `wapen` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ammo` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `components` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumpen data van tabel s30339_fezco.fezco_loodsenopslag_weapons: ~1 rows (ongeveer)
/*!40000 ALTER TABLE `fezco_loodsenopslag_weapons` DISABLE KEYS */;
/*!40000 ALTER TABLE `fezco_loodsenopslag_weapons` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
