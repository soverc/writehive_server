--
-- Table structure for table `sites`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `sites` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `user_id` int(255) unsigned default NULL,
  `url` varchar(200) default NULL,
  `description` text,
  `date_created` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1597 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;


