--
-- Table structure for table `errors`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `errors` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `code` varchar(25) default NULL,
  `label` varchar(75) default NULL,
  `message` text,
  `redirect` varchar(25) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=MyISAM AUTO_INCREMENT=159789 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


