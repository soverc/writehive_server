--
-- Table structure for table `xmlrpc_log`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `xmlrpc_log` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `action` text,
  `parameters` text,
  `api_key` varchar(17) default NULL,
  `debug_data` text,
  `date_executed` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1774 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


