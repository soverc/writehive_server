--
-- Table structure for table `message_log`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `message_log` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `to` varchar(250) default NULL,
  `from` varchar(250) default NULL,
  `subject` text,
  `message` text,
  `timestamp` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=81 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


