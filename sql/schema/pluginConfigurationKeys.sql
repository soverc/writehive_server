--
-- Table structure for table `pluginConfigurationKeys`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `pluginConfigurationKeys` (
  `iConfigurationId` int(255) unsigned NOT NULL auto_increment,
  `iConfigurationSectionId` int(255) unsigned default NULL,
  `sConfigurationName` varchar(150) default NULL,
  `sConfigurationValue` text,
  `sConfigurationBranch` enum('production','beta','development') NOT NULL default 'production',
  `sConfigurationComment` text,
  PRIMARY KEY  (`iConfigurationId`)
) ENGINE=MyISAM AUTO_INCREMENT=81 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

