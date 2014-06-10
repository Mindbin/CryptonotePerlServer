--
-- Table structure for table `noteData`
--
DROP TABLE IF EXISTS `noteData`;
CREATE TABLE `noteData` (
  `id` varchar(128) NOT NULL,
  `login` varchar(64) NOT NULL,
  `ip` varchar(64) NOT NULL,
  `data` longtext,
  PRIMARY KEY (`id`),
  KEY `id_login` (`id`,`login`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `noteData` WRITE;
UNLOCK TABLES;
