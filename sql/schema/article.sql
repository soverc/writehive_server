--
-- Table structure for table `article`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `article` (
  `article_id` CHAR(37) NOT NULL,
  `author_id` CHAR(37) NULL default NULL,
  `date_created` datetime default NULL,
  `content` longtext,
  `title` text,
  `description` text,
  `name` varchar(200) default NULL,
  `last_modified` datetime default NULL,
  `category_id` int(255) unsigned default NULL,
  `secondcategory_id` int(255) unsigned default NULL,
  `subcategory_id` int(255) unsigned default NULL,
  `secondsubcategory_id` int(255) unsigned default NULL,
  `from_url` varchar(250) default NULL,
  `from_blog` varchar(250) default NULL,
  `license`  char(30) default 'writehive-sharing-1.0',
  `allow_free` tinyint(1) unsigned default '1',
  `group_id` int(255) unsigned default '0',
  `private` tinyint(1) unsigned default '0',
  `tag_words` text,
  `cost` decimal(10,2) unsigned NOT NULL default '0.00',
  `active` tinyint(1) unsigned NOT NULL default '1',
  PRIMARY KEY  (`article_id`)
) ENGINE=MyISAM AUTO_INCREMENT=60997 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;


