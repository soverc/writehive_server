--
-- Table structure for table `json_rpc_log`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `json_rpc_log` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `method` varchar(50) default NULL,
  `key` varchar(25) default NULL,
  `raw_data` text,
  `ts` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=450083 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


