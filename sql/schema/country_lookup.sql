--
-- Table structure for table `country_lookup`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `country_lookup` (
  `iso` char(2) NOT NULL,
  `name` varchar(80) NOT NULL,
  `printable_name` varchar(80) NOT NULL,
  `iso3` char(3) default NULL,
  `numcode` smallint(6) default NULL,
  PRIMARY KEY  (`iso`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


