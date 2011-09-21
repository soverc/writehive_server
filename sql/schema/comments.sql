--
-- Table structure for table `comments`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `article_id` int(255) unsigned default NULL,
  `author_id` int(255) unsigned default NULL,
  `author_name` varchar(150) default NULL,
  `author_email` varchar(150) default NULL,
  `author_url` varchar(200) default NULL,
  `author_ip` varchar(11) default NULL,
  `date_created` datetime default NULL,
  `content` text,
  `parent_id` int(255) unsigned default NULL,
  `site_id` int(255) unsigned default NULL,
  `from_blog` varchar(255) default NULL,
  `from_url` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1903 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;


