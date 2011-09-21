--
-- Table structure for table `views`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `views` (
  `entity_id` int(255) unsigned default NULL,
  `entity_type` enum('page','comment','article') default NULL,
  `viewed_by` varchar(15) default NULL,
  `viewed` timestamp NULL default NULL,
  `meta` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


