--
-- Table structure for table `pluginConfigurationSections`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `pluginConfigurationSections` (
  `iSectionId` int(255) unsigned NOT NULL auto_increment,
  `sSectionName` varchar(150) default NULL,
  `sSectionBranch` enum('production','beta','development') NOT NULL default 'production',
  PRIMARY KEY  (`iSectionId`)
) ENGINE=MyISAM AUTO_INCREMENT=218 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

