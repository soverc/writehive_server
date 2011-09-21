<?php 

ini_set('display_errors',0); 
if (function_exists('date_default_timezone_set')) {
	date_default_timezone_set( @date_default_timezone_get() );
}

$libs = array('xmlrpc.inc', 'xmlrpcs.inc', 'xmlrpc_wrappers.inc');
foreach ($libs as $_l) {
	if(!include_once( 
		implode(DIRECTORY_SEPARATOR, 
			array( dirname(dirname(__FILE__)), 'library', 'XmlRpc', $_l)))) {
		echo json_encode( array('error'=>'unable to open requried libraries'));
		exit();
	}
}
if(!include_once( 
	implode(DIRECTORY_SEPARATOR, 
		array( dirname(dirname(__FILE__)), 'library', 'MediaPlace.php')))) {
	echo json_encode( array('error'=>'unable to open requried libraries'));
	exit();
}

	// Create Connection to DB
	$mp = new MediaPlace();
	
	// Ping Service
	function test_ping($args)
	{
		global $mp;
			$mp->log('test.ping', json_encode($args), '', $GLOBALS['HTTP_RAW_POST_DATA']);
			
		return(new xmlrpcresp(new xmlrpcval(array(
			'now'    => new xmlrpcval(date('Fj Y G:i a'), 'string')
		), 'struct')));
	}
	
	// Logon Function
	function oneighty_logon($args)
	{
		global $mp;
			$mp->log('oneighty.logon', json_encode($args), null, $GLOBALS['HTTP_RAW_POST_DATA']);
	
		$username = $args->getParam(0)->scalarval();
		$password = $args->getParam(1)->scalarval();
		$user     = $mp->login($username, $password);
	
		if ($user) {
			// Remove Password
			unset($user->passwd);
			
			// Return the user
			return(new xmlrpcresp(new xmlrpcval(array(
				'user' => new xmlrpcval(json_encode($user), 'string')
			), 'struct')));
		} else {
			return(new xmlrpcresp(new xmlrpcval(array(
				'error'    => new xmlrpcval('Invalid credentials!', 'string'), 
				'username' => new xmlrpcval($username, 'string'),
				'password' => new xmlrpcval($password, 'string')
			), 'struct')));
		}
	}
	
	// Search Articles
	function oneighty_search($args)
	{
		global $mp;
			$mp->log('oneighty.search', json_encode($args), $args->getParam(0)->scalarval(), $GLOBALS['HTTP_RAW_POST_DATA']);
		
		if ($mp->valid_api_key($args->getParam(0)->scalarval())) {
			$query = array(
				'criteria'    => $args->getParam(1)->scalarval()
			  # 'start_date'  => @$_args[2],
			  # 'end_date'    => @$_args[3],
		      # 'category'    => @$_args[4],
		      # 'subcategory' => @$_args[5],
			  # 'tag_words'   => @$_args[6]
			);
			return(new xmlrpcresp(new xmlrpcval(addslashes(json_encode($mp->article_search($query))), 'string')));
		} else {
			return(new xmlrpcresp(new xmlrpcval(array(
				'error' => new xmlrpcval('Invalid API Key!',              'string'),
				'key'   => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
			), 'struct')));
		}
	}
	
	// Grab Article
	function oneighty_fetch($args)
	{
		global $mp;
			$mp->log('oneighty.grab_article', json_encode($args), $args->getParam(0)->scalarval(), $GLOBALS['HTTP_RAW_POST_DATA']);
		
		if ($mp->valid_api_key($args->getParam(0)->scalarval())) {
			$article = $mp->article_fetch($args->getParam(1)->scalarval());
			
			return(new xmlrpcresp(new xmlrpcval(array(
				'article' => new xmlrpcval(addslashes(json_encode($article)), 'string'), 
				'id'      => new xmlrpcval($article->id,                      'string'), 
				'key'     => new xmlrpcval($args->getParam(0)->scalarval(),   'string')
			), 'struct')));
		} else {
			return(new xmlrpcresp(new xmlrpcval(array(
				'error' => new xmlrpcval('Invalid API Key!',              'string'), 
				'key'   => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
			), 'struct')));
		}
	}
	
	// Grab Categories
	function oneighty_categories($args)
	{
		global $mp;
			$mp->log('oneighty.categories', json_encode($args), $args->getParam(0)->scalarval(), $GLOBALS['HTTP_RAW_POST_DATA']);
		
		if ($mp->valid_api_key($args->getParam(0)->scalarval())) {
			return(new xmlrpcresp(new xmlrpcval(array(
				'categories' => new xmlrpcval(json_encode($mp->grab_categories()), 'string')
			), 'struct')));
		} else {
			return(new xmlrpcresp(new xmlrpcval(array(
				'error' => new xmlrpcval('Invalid API Key', 'string'), 
				'key'   => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
			), 'struct')));
		}
	}

	// Grab Subcategories
	function oneighty_subcategories($args)
	{
		global $mp;
			$mp->log('oneighty.subcategories', json_encode($args), $args->getParam(0)->scalarval(), $GLOBALS['HTTP_RAW_POST_DATA']);
		
		if ($mp->valid_api_key($args->getParam(0)->scalarval())) {
			return(new xmlrpcresp(new xmlrpcval(array(
				'categories' => new xmlrpcval(json_encode($mp->grab_subcategories($args->getParam(1)->scalarval())), 'string')
			), 'struct')));
		} else {
			return(new xmlrpcresp(new xmlrpcval(array(
				'error'    => new xmlrpcval('Invalid API Key', 'string'), 
				'key'      => new xmlrpcval($args->getParam(0)->scalarval(), 'string'), 
				'category' => new xmlrpcval($args->getParam(1)->scalarval(), 'string')
			), 'struct')));
		}
	}
	
	// Grab User's Groups
	function oneighty_groups($args)
	{
		global $mp;
			$mp->log('oneighty.groups', json_encode($args), $args->getParam(0)->scalarval(), $GLOBALS['HTTP_RAW_POST_DATA']);
			
		if ($mp->valid_api_key($args->getParam(0)->scalarval())) {
			return(new xmlrpcresp(new xmlrpcval(array(
				'groups' => new xmlrpcval(json_encode($mp->my_groups($args->getParam(1)->scalarval())), 'string')
			), 'struct')));
		} else {
			return(new xmlrpcresp(new xmlrpcval(array(
				'error' => new xmlrpcval('Invalid API Key', 'string'), 
				'key'   => new xmlrpcval($args->getParam(0)->scalarval(), 'string'), 
				'user'  => new xmlrpcval($args->getParam(1)->scalarval(), 'string')
			), 'struct')));
		}
	}
	
	// Post an article
	function oneighty_post($args)
	{
		global $mp;
			$mp->log('oneighty.post', json_encode($args), $args->getParam(0)->scalarval(), $GLOBALS['HTTP_RAW_POST_DATA']);
		
		if ($mp->valid_api_key($args->getParam(0)->scalarval())) {
			$id = $mp->article_post(json_decode($args->getParam(1)->scalarval()));
				
			if ($id) {
				return(new xmlrpcresp(new xmlrpcval(array(
					'success' => new xmlrpcval(1, 'int'), 
					'id'      => new xmlrpcval($id, 'string'), 
					'article' => new xmlrpcval(json_encode($mp->article_fetch($id)), 'string')
				), 'struct')));
			} else {
				return(new xmlrpcresp(new xmlrpcval(array(
					'error' => new xmlrpcval('We were unable to save your article at this time.', 'string'), 
					'id'    => new xmlrpcval($id, 'string'), 
					'key'   => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
				), 'struct')));
			}
		} else {
			return(new xmlrpcresp(new xmlrpcval(array(
				'error' => new xmlrpcval('Invalid API Key!', 'string'), 
				'key'   => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
			), 'struct')));
		}
	}
	
	// Increment the syndications of an article
	function oneighty_syndicate_plus_one($args)
	{
		global $mp;
			$mp->log('oneighty.syndicateplusone', json_encode($args), $args->getParam(0)->scalarval(), $GLOBALS['HTTP_RAW_POST_DATA']);
		
		if ($mp->valid_api_key($args->getParam(0)->scalarval())) {
			if ($mp->article_increment_syndications($args->getParam(1)->scalarval(), $args->getParam(2)->scalarval())) {
				return(new xmlrpcresp(new xmlrpcval(array(
					'success' => new xmlrpcval(1, 'int'), 
					'key'     => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
				), 'struct')));
			} else {
				return(new xmlrpcresp(new xmlrpcval(array(
					'success' => new xmlrpcval(0, 'int'), 
					'error'   => new xmlrpcval('There was an error while trying to update syndication statistics for this article.', 'string'), 
					'key'     => new xmlrpcval($args->getParam(0)->scalarval(), 'string'), 
					'article' => new xmlrpcval($args->getParam(1)->scalarval(), 'string'), 
					'user'    => new xmlrpcval($args->getParam(2)->scalarval(), 'string')
				), 'struct')));
			}
		} else {
			return(new xmlrpcresp(new xmlrpcval(array(
				'error' => new xmlrpcval('Invalid API Key!', 'string'), 
				'key'   => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
			), 'struct')));
		}
	}
	
	// Grab Comments
	function oneighty_comments_grab($args)
	{
		global $mp;
			$mp->log('comments.comments_grab', json_encode($args), $args->getParam(0)->scalarval(), $GLOBALS['HTTP_RAW_POST_DATA']);
		
		if ($mp->valid_api_key($args->getParam(0)->scalarval())) {
			if ($comments = $mp->comments_grab($args->getParam(1)->scalarval())) {
				return(new xmlrpcresp(new xmlrpcval(array(
					'success'  => new xmlrpcval(1, 'int'), 
					'comments' => new xmlrpcval(addslashes(json_encode($comments)), 'string'), 
					'post'     => new xmlrpcval($args->getParam(1)->scalarval(),    'string'), 
					'key'      => new xmlrpcval($args->getParam(0)->scalarval(),    'string')
				), 'struct')));
			} else {
				return(new xmlrpcresp(new xmlrpcval(array(
					'success' => new xmlrpcval(0, 'int'), 
					'error'   => new xmlrpcval('We could not fetch the comments for the requested post at this time.', 'string'), 
					'key'     => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
				), 'struct')));
			}
		} else {
			return(new xmlrpcresp(new xmlrpcval(array(
				'error' => new xmlrpcval('Invalid API Key!', 'string'), 
				'key'   => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
			), 'struct')));
		}
	}
	
	// Post Comment
	function oneighty_comments_post($args)
	{
		global $mp;
			$mp->log('comments.post', json_encode($args), $args->getParam(0)->scalarval(), $GLOBALS['HTTP_RAW_POST_DATA']);
			
		if ($mp->valid_api_key($args->getParam(0)->scalarval())) {
			if ($mp->comment_post(json_decode($args->getParam(1)->scalarval()))) {
				return(new xmlrpcresp(new xmlrpcval(array(
					'success' => new xmlrpcval(1,                               'int'),  
					'key'     => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
				), 'struct')));
			} else {
				return(new xmlrpcresp(new xmlrpcval(array(
					'success' => new xmlrpcval(0,                                                  'int'), 
					'error'   => new xmlrpcval('We were unable to post your comment at this time', 'string'), 
					'key'     => new xmlrpcval($args->getParam(0)->scalarval(),                    'string')
				), 'struct')));
			}
		} else {
			return(new xmlrpcresp(new xmlrpcval(array(
				'error' => new xmlrpcval('Invalid API Key!',              'string'), 
				'key'   => new xmlrpcval($args->getParam(0)->scalarval(), 'string')
			), 'struct')));
		}
	}
	
	// Create the Server
	$server = new xmlrpc_server(array(
		'test.ping' => array(
			'function' => 'test_ping'
		),
		 
		'oneighty.logon' => array(
			'function'  => 'oneighty_logon'
		), 
		
		'oneighty.search' => array(
			'function' => 'oneighty_search'
		), 
		
		'oneighty.grab_article' => array(
			'function' => 'oneighty_fetch'
		), 
		
		'oneighty.categories' => array(
			'function' => 'oneighty_categories'
		), 
		
		'oneighty.subcategories' => array(
			'function' => 'oneighty_subcategories'
		), 
		
		'oneighty.groups' => array(
			'function' => 'oneighty_groups'
		), 
		
		'oneighty.post' => array(
			'function' => 'oneighty_post'
		), 
		
		'oneighty.syndicateplusone' => array(
			'function' => 'oneighty_syndicate_plus_one'
		), 
		
		'comments.grab' => array(
			'function' => 'oneighty_comments_grab'
		), 
		
		'comments.post' => array(
			'function' => 'oneighty_comments_post'
		)
	), false);
	
	// Set Compression
	$server->compress_response = true;
	
	// Set Response Encoding
	$server->response_charset_encoding = 'auto';
	
	// Start the service
	$server->service();
?>
