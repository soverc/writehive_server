--
-- Table structure for table `syndicated`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `syndicated` (
  `uid` CHAR(37) NOT NULL default '',
  `aid` CHAR(37) NOT NULL default '',
  `sid` int(255) unsigned default NULL,
  `syndicated` datetime default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


