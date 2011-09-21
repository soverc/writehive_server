--
-- Table structure for table `invoices`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` int(255) unsigned NOT NULL auto_increment,
  `author_id` int(255) unsigned default '0',
  `article_id` int(255) unsigned default '0',
  `invoice_type` enum('article','membership','telephony') default NULL,
  `amount` decimal(10,2) unsigned NOT NULL default '0.00',
  `date_purchased` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


