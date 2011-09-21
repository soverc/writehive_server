--
-- Table structure for table `group_applications`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `group_applications` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `gid` int(255) unsigned default NULL,
  `uid` int(255) unsigned default NULL,
  `applied` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


