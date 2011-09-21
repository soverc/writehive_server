--
-- Table structure for table `subcategories`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `subcategories` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `category_id` int(255) default NULL,
  `label` varchar(125) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1964 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


