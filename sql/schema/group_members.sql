--
-- Table structure for table `group_members`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `group_members` (
  `uid` int(255) unsigned default NULL,
  `gid` int(255) unsigned default NULL,
  `joined` timestamp NULL default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

