--
-- Table structure for table `people_to_invite`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `people_to_invite` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `email_address` varchar(250) default NULL,
  `category_id` int(255) unsigned default NULL,
  `other_id` int(255) unsigned default NULL,
  `created` timestamp NULL default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `email_address` (`email_address`)
) ENGINE=MyISAM AUTO_INCREMENT=98 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


