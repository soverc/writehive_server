--
-- Table structure for table `groups`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `groups` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `name` varchar(75) default NULL,
  `logo` varchar(255) default NULL,
  `description` text,
  `privilege` tinyint(1) unsigned NOT NULL default '1',
  `date_created` timestamp NULL default NULL,
  `website` varchar(255) default NULL,
  `category` int(255) unsigned default NULL,
  `subcategory` int(255) unsigned default NULL,
  `taga` varchar(25) default NULL,
  `tagb` varchar(25) default NULL,
  `listed` tinyint(1) unsigned NOT NULL default '1',
  `zip` varchar(10) default NULL,
  `creator` int(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


