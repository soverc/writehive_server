<?php 
ini_set('date.timezone', 'America/New_York');
	class MediaPlace
	{
		private $_dbx;

		public function __construct()
		{
			//$this->_dbx = new mysqli('10.100.100.104', 'mpdb', 'mpFj8*Qm159788', 'mediaplace');
			$this->_dbx = new mysqli('localhost', 'root', '', 'mediaplace');
		}
		
		public function valid_api_key($_key)
		{
			$_user = $this->_dbx->query("SELECT id FROM users WHERE account_key = '".strip_tags($_key)."'");
			$_user = $_user->fetch_object();
			
			if ($_user->id) {
				return(true);
			} else {
				return(false);
			}
		}
		
		public function log($_method, $_data)
		{
			$_sql = "INSERT INTO json_rpc_log (
				method, 
				raw_data, 
				ts
			) VALUES (
				'{$this->__sanitize($_method)}', 
				'".$this->_dbx->real_escape_string($_data)."',  
				NOW()
			)";
			
			if ($this->_dbx->query($_sql)) {
				return(true);
			} else {
				return(false);
			}
		}

		public function load_plugin_config() 
		{
			$sSectionSql = "SELECT * FROM `pluginConfigurationSections`;";
			$rSections   = $this->_dbx->query($sSectionSql);
			$aIni        = array();

			while ($oSection = $rSections->fetch_object()) {
				$aIni[$oSection->sSectionName] = array();
				$sVariableSql                  = "SELECT * FROM `pluginConfigurationKeys` WHERE `iConfigurationSectionId` = {$oSection->iSectionId};";
				$rVariables                    = $this->_dbx->query($sVariableSql);

				while ($oVariable = $rVariables->fetch_object()) {
					$aIni[$oSection->sSectionName][$oVariable->sConfigurationName] = $oVariable->sConfigurationValue;
				}
			}

			return $aIni;
		}
		
		public function login($_username, $_password)
		{
			$_user = $this->_dbx->query("SELECT * FROM users WHERE display_name = '{$this->__sanitize($_username)}' AND passwd = PASSWORD('{$this->__sanitize($_password)}')");
			$_user = $_user->fetch_object();
			
			if ($_user->id) {
				return($_user);
			} else {
				return(false);
			}
		}

		public function api_login($_key) {
			$_user = $this->_dbx->query("SELECT * FROM users WHERE account_key = '{$this->__sanitize($_key)}'");
			$_user = $_user->fetch_object();

			if ($_user->id) { 
				return($_user);
			} else {
				return(false);
			}
		}
		
		public function fetch_user($_id)
		{
			$_user = $this->_dbx->query("SELECT * FROM users WHERE id = {$this->__sanitize($_id)}");
			$_user = $_user->fetch_object();
			
			if ($_user->id) {
				return($_user);
			} else {
				return(false);
			}
		}
		
		public function article_search($_query)
		{
			$_results  = array();
			$_q        = "SELECT a.*, c.label AS cat_label, s.label AS subcat_label, u.display_name "; 
			$_q       .= "FROM articles a INNER JOIN categories c ON (c.id = a.category_id) ";
            $_q       .= "LEFT JOIN categories d ON (d.id = a.secondcategory_id) ";
			$_q       .= "LEFT JOIN subcategories s ON (s.id = a.subcategory_id) ";
			$_q       .= "INNER JOIN users u ON (u.id = a.author_id) WHERE ";
			$_q       .= "a.title LIKE '%{$this->__sanitize($_query['criteria'])}%' OR a.content LIKE '%{$this->__sanitize($_query['criteria'])}%' ";
			$_q       .= "OR a.description LIKE '%{$this->__sanitize($_query['criteria'])}%' OR ";
			$_q       .= "a.tag_words LIKE ".((isset($_query['tag_words'])) ? "'%{$this->__sanitize($_query['tag_words'])}%'" : "'%{$this->__sanitize($_query['criteria'])}%'");
	
			if (isset($_query['start_date']) && isset($_query['end_date'])) {
				$_q .= " OR (a.date_created BETWEEN '".date('Y-m-d', strtotime($this->__sanitize($_query['start_date'])))."' AND '".date('Y-m-d', strtotime($this->__sanitize($_query['end_date'])))."')";
			}
	
			elseif (isset($_query['start_date'])) {
				$_q .= " OR (a.date_created >= ".date('Y-m-d', strtotime($this->__sanitize($_query['start_date'])))."')";
			}
	
			elseif (isset($_query['end_date'])) {
				$_q .= " OR (a.date_created <= ".date('Y-m-d', strtotime($this->__sanitize($_query['end_date'])))."')";
			}
	
			if (isset($_query['category'])) {
				$_q .= " AND a.category_id = {$this->__sanitize($_query['category'])}";
			}
	
			if (isset($_query['secondcategory'])) {
				$_q .= " AND s.id = {$this->__sanitize($_query['secondcategory'])}";
			}

			$_search = $this->_dbx->query($_q);
			
			while ($_article = $_search->fetch_object()) {
                if ($_article->active) {
                    $_article->content      = $this->__secure_desanitize($_article->content);
                    $_article->comments     = $this->__article_comments($_article->id);
                    $_article->syndications = $this->__article_syndications($_article->id);
                    $_article->purchases    = $this->__article_purchases($_article->id);
                    $_article->views        = $this->__article_views($_article->id);
                    $_results[]             = $_article;
                }
			}
			
			return($_results);
		}

        public function article_deactivate($_article_id)
        {
            $_q = "UPDATE `articles` SET `active` = 0 WHERE `id` = {$this->__sanitize($_article_id)}";

            if ($this->_dbx->query($_q)) {
                return true;
            } else {
                return false;
            }
        }
		
		public function article_fetch($_article_id)
		{
			$_article               = $this->_dbx->query('SELECT a.*, u.display_name AS author_name, c.label AS cat_label, d.label AS secondcat_label, s.label as subcat_label, e.label AS secondsubcat_label FROM articles AS a INNER JOIN users AS u ON (u.id = a.author_id) INNER JOIN categories AS c ON (c.id = a.category_id) LEFT JOIN categories AS d ON (d.id = a.secondcategory_id) LEFT JOIN subcategories AS s ON (s.id = a.subcategory_id) LEFT JOIN subcategories AS e ON (e.id = a.secondsubcategory_id) WHERE a.id = '.strip_tags($_article_id));
			$_article               = $_article->fetch_object();
			$_article->content      = $this->__secure_desanitize($_article->content);
			$_article->comments     = $this->__article_comments($_article->id);
			$_article->syndications = $this->__article_syndications($_article->id);
			$_article->purchases    = $this->__article_purchases($_article->id);
			$_article->views        = $this->__article_views($_article->id);
				return($_article);
		}
		
		public function grab_all_categories()
		{
			$_categories = array();
			$_cats       = $this->_dbx->query("SELECT * FROM categories ORDER BY `order` ASC");
			
			while ($_cat = $_cats->fetch_object()) {
				$_categories[] = $_cat;
			}
			
			return($_categories);
		}
		
		public function grab_categories()
		{
			$_categories = array();
			$_cats       = $this->_dbx->query("SELECT * FROM categories WHERE active = 1 ORDER BY `order` ASC");
			
			while ($_cat = $_cats->fetch_object()) {
				$_categories[] = $_cat;
			}
			
			return($_categories);
		}
		
		public function grab_subcategories($_category)
		{
			$_categories = array();
			$_cats       = $this->_dbx->query("SELECT * FROM subcategories WHERE category_id = {$this->__sanitize($_category)}");
			
			while ($_cat = $_cats->fetch_object()) {
				$_categories[] = $_cat;
			}
			
			return($_categories);
		}
		
		public function article_post($_data)
		{	
			$_sql      = "INSERT INTO articles (
				author_id, 
				content, 
				title, 
				description, 
				name, 
				category_id, 
				secondcategory_id, 
				subcategory_id, 
				secondsubcategory_id, 
				group_id, 
				private, 
				tag_words, 
				cost, 
				date_created, 
				from_blog, 
				from_url, 
				allow_free
			) VALUES (
				'{$this->__sanitize($_data->author_id)}', 
				'{$this->__secure_sanitize($_data->content)}', 
				'{$this->__sanitize($_data->title)}', 
				'{$this->__sanitize($_data->description)}', 
				'{$this->__sanitize($_data->name)}', 
				'{$this->__sanitize($_data->category_id)}', 
				'{$this->__sanitize($_data->secondcategory_id)}', 
				'{$this->__sanitize($_data->subcategory_id)}', 
				'{$this->__sanitize($_data->secondsubcategory_id)}', 
				'{$this->__sanitize($_data->group_id)}', 
				'{$this->__sanitize($_data->private)}', 
				'{$this->__sanitize($_data->tag_words)}', 
				'{$this->__sanitize($_data->cost)}', 
				NOW(), 
				'{$this->__sanitize($_data->from_blog)}', 
				'{$this->__sanitize($_data->from_url)}', 
				'{$this->__sanitize($_data->allow_free)}'
			)";
			
			if ($this->_dbx->query($_sql)) {
				return($this->_dbx->insert_id);
			} else {
				return(false);
			}
		}
		
		public function article_increment_syndications($_article, $_user)
		{	
			if ($this->_dbx->query("INSERT INTO syndicated (uid, aid, syndicated) VALUES ('".strip_tags($_user)."', '".strip_tags($_article)."', NOW())")) {
				return(true);
			} else {
				return(false);
			}
		}
		
		public function comments_grab($_article)
		{
			$_comments = array();
			$_comm     = $this->_dbx->query("SELECT * FROM comments WHERE article_id = '{$this->__sanitize($_article)}'");
			
			while ($_comment = $_comm->fetch_object()) {
				$_comment->content = $this->__secure_desanitize($_comment->content);
				$_comments[]       = $_comment;
			}
			
			return($_comments);
		}
		
		public function comment_post($_comment)
		{
			$_sql = "INSERT INTO comments (
				article_id, 
				author_name, 
				author_email, 
				author_url, 
				author_ip, 
				date_created, 
				content, 
				parent_id, 
				site_id, 
				from_blog, 
				from_url
			) VALUES (
				'{$this->__sanitize($_comment->article_id)}', 
				'{$this->__sanitize($_comment->author_name)}', 
				'{$this->__sanitize($_comment->author_email)}', 
				'{$this->__sanitize($_comment->author_url)}', 
				'{$this->__sanitize($_comment->author_ip)}', 
				NOW(), 
				'{$this->__secure_sanitize($_comment->content)}', 
				'{$this->__sanitize($_comment->parent_id)}', 
				'{$this->__sanitize($_comment->site_id)}', 
				'{$this->__sanitize($_comment->from_blog)}', 
				'{$this->__sanitize($_comment->from_url)}' 
			)";
						
			if ($this->_dbx->query($_sql)) {
				return(true);
			} else {
				return(false);
			}
		}
		
		public function my_groups($_user)
		{
			$_owned  = array();
			$_joined = array();
			$_all    = array();
			$_oq     = $this->_dbx->query("SELECT * FROM groups WHERE creator = '".$this->__sanitize($_user)."'");
			$_jq     = $this->_dbx->query("SELECT j.*, g.* FROM group_members j INNER JOIN groups g ON (j.gid = g.id) WHERE uid = '".$this->__sanitize($_user)."'");
			
			while ($_row = $_oq->fetch_object()) {
				$_owned[] = $_row;
			}
			
			while ($_row = $_jq->fetch_object()) {
				$_joined[] = $_row;
			}
			
			foreach ($_owned as $_group) {
				$_all[] = $_group;
			}
			
			foreach ($_joined as $_group) {
				$_all[] = $_group;
			}
			
			return(array(
				'owned'  => $_owned, 
				'joined' => $_joined, 
				'all'    => $_all
			));
		}
		
		private function __sanitize($_string)
		{
			return(addslashes(strip_tags($_string)));
		}
		
		private function __secure_sanitize($_string)
		{
			return(addslashes(htmlentities($_string)));
		}
		
		private function __secure_desanitize($_string)
		{
			return(html_entity_decode($_string));
		}
		
		private function __article_comments($_article)
		{
			$_comments = $this->_dbx->query("SELECT COUNT(id) AS comment_count FROM comments WHERE article_id = ".strip_tags($_article));
			$_comments = $_comments->fetch_object();
				return($_comments->comment_count);
		}
		
		private function __article_syndications($_article)
		{
			$_syndications = $this->_dbx->query("SELECT COUNT(aid) AS syndication_count FROM syndicated WHERE aid = ".strip_tags($_article));
			$_syndications = $_syndications->fetch_object();
				return($_syndications->syndication_count);
		}
		
		private function  __article_purchases($_article)
		{
			$_purchases = $this->_dbx->query("SELECT COUNT(article_id) AS purchase_count FROM invoices WHERE article_id = ".strip_tags($_article));
			$_purchases = $_purchases->fetch_object();  
				return($_purchases->purchase_count);
		}
		
		private function __article_views($_article)
		{
			$_views = $this->_dbx->query("SELECT COUNT(entity_id) AS view_count FROM views WHERE entity_id = ".strip_tags($_article)." AND entity_type = 'article'");
			$_views = $_views->fetch_object();
				return($_views->view_count);
		}

	}
