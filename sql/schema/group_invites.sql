--
-- Table structure for table `group_invites`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `group_invites` (
  `token` varchar(25) default NULL,
  `gid` int(255) unsigned default NULL,
  `uid` int(255) unsigned default NULL,
  `email` varchar(250) default NULL,
  `used` tinyint(1) unsigned default '0',
  `created` timestamp NULL default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


