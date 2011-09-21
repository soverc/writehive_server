--
-- Table structure for table `state_lookup`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `state_lookup` (
  `id` int(11) NOT NULL auto_increment,
  `name` char(40) NOT NULL,
  `abbrev` char(2) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=66 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


