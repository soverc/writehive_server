--
-- Temporary table structure for view `v_user_article_stats`
--

DROP TABLE IF EXISTS `v_user_article_stats`;
/*!50001 DROP VIEW IF EXISTS `v_user_article_stats`*/;
/*!50001 CREATE TABLE `v_user_article_stats` (
  `id` int(255) unsigned,
  `author_id` int(255) unsigned,
  `date_created` datetime,
  `title` text,
  `cost` decimal(10,2) unsigned,
  `cat_label` varchar(125),
  `secondcat_label` varchar(125),
  `subcat_label` varchar(125),
  `secondsubcat_label` varchar(125),
  `comments` bigint(21),
  `syndications` bigint(21),
  `purchases` bigint(21),
  `views` bigint(21)
) ENGINE=MyISAM */;

--
-- Final view structure for view `v_user_article_stats`
--

/*!50001 DROP TABLE `v_user_article_stats`*/;
/*!50001 DROP VIEW IF EXISTS `v_user_article_stats`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mpdb`@`WEBSERVER` SQL SECURITY DEFINER */
/*!50001 VIEW `v_user_article_stats` AS select `a`.`id` AS `id`,`a`.`author_id` AS `author_id`,`a`.`date_created` AS `date_created`,`a`.`title` AS `title`,`a`.`cost` AS `cost`,`c`.`label` AS `cat_label`,`d`.`label` AS `secondcat_label`,`s`.`label` AS `subcat_label`,`t`.`label` AS `secondsubcat_label`,(select count(`mediaplace`.`comments`.`article_id`) AS `comment_count` from `comments` where (`mediaplace`.`comments`.`article_id` = `a`.`id`)) AS `comments`,(select count(`mediaplace`.`syndicated`.`aid`) AS `count(aid)` from `syndicated` where (`mediaplace`.`syndicated`.`aid` = `a`.`id`)) AS `syndications`,(select count(`mediaplace`.`invoices`.`article_id`) AS `count(article_id)` from `invoices` where (`mediaplace`.`invoices`.`article_id` = `a`.`id`)) AS `purchases`,(select count(`mediaplace`.`views`.`entity_id`) AS `count(entity_id)` from `views` where ((`mediaplace`.`views`.`entity_id` = `a`.`id`) and (`mediaplace`.`views`.`entity_type` = _latin1'article'))) AS `views` from ((((`articles` `a` left join `categories` `c` on((`c`.`id` = `a`.`category_id`))) left join `categories` `d` on((`d`.`id` = `a`.`secondcategory_id`))) left join `subcategories` `s` on((`s`.`id` = `a`.`subcategory_id`))) left join `subcategories` `t` on((`t`.`id` = `a`.`secondsubcategory_id`))) */;

