--
-- Table structure for table `categories`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `label` varchar(125) default NULL,
  `order` int(5) unsigned NOT NULL default '0',
  `active` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1632 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

