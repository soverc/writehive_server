--
-- Table structure for table `users`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `user` (
--  `id` int(255) unsigned NOT NULL auto_increment,
  `user_id` CHAR(37) NOT NULL default '',
  `display_name` varchar(50) default NULL,
  `passwd` varchar(50) default NULL,
  `first_name` varchar(45) default NULL,
  `last_name` varchar(45) default NULL,
  `email_address` varchar(150) default NULL,
  `street_address` varchar(150) default NULL,
  `street_address2` varchar(250) default NULL,
  `city` varchar(50) default NULL,
  `country` varchar(250) default NULL,
  `state` char(2) default NULL,
  `zip_code` int(5) default NULL,
  `date_of_birth` date default NULL,
  `gender` int(1) unsigned default NULL,
  `paypal` varchar(150) default NULL,
  `account_key` varchar(17) default NULL,
  `date_created` datetime default NULL,
  `date_updated` datetime default NULL,
  `role` int(1) unsigned default NULL,
  `bio` text,
  `display_pic` varchar(30) default NULL,
  `category_id` int(255) default NULL,
  `is_beta` tinyint(1) unsigned NOT NULL default '0',
  `active` tinyint(1) unsigned NOT NULL default '1',
  `group_id` int(255) unsigned NOT NULL default '0',
  `member_type` enum('free','plus','premium') NOT NULL default 'free',
  `website` varchar(250) default NULL,
  `facebook` varchar(250) default NULL,
  `twitter` varchar(250) default NULL,
  `linkedin` varchar(250) default NULL,
  PRIMARY KEY  (`user_id`),
  UNIQUE KEY `display_name` (`display_name`)
) ENGINE=MyISAM AUTO_INCREMENT=1734 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


