<?php 

ini_set('display_errors',0); 
//error_reporting(E_ALL); 


if (function_exists('date_default_timezone_set')) {
	date_default_timezone_set( @date_default_timezone_get() );
}

//if we're always going to send JSON
//then we must never display an error (it corrups the valid JSON output)
header('Content-type: application/json'); 

if(!include_once( implode(DIRECTORY_SEPARATOR, array( dirname(dirname(__FILE__)), 'library', 'MediaPlace.php')))) {
	echo json_encode( array('error'=>'unable to open requried libraries'));
	exit();
}

	$_mp       = new MediaPlace();
	$_json     = file_get_contents("php://input");
	$_data     = json_decode($_json);
	$_response = null;

	switch($_data->_method) {
		
		# Logon Method
		case 'logon' : 

			$_user = $_mp->login($_data->username, $_data->passwd);
			
			if ($_user->user_id) {
				unset($_user->passwd);
					$_response = $_user;
			} else {
				$_response = array(
					'error' => 'Invalid credentials.'
				);
			}
			break;

		# Load plugin configurations
		case 'load_config' : 

			$_response = $_mp->load_plugin_config();

			break;

		# Logon with just API Key
		case 'api_logon' : 
			if ($_mp->valid_api_key($_data->_key)) {
				$_user = $_mp->api_login($_data->_key);

				if ($_user->id) {
					unset($_user->passwd);
						$_response = $_user;
				} else {
					$_response = array(
						'error' => 'We were unable to fetch your user data at this time.  Please try again later.'	
					);
				}
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;
			
		# Fetch User
		case 'fetch_user' : 
			if ($_mp->valid_api_key($_data->_key)) {
				$user = $_mp->fetch_user($_data->user_id);
				
				if ($user->id) {
					unset($user->passwd);
						$_response = $user;
				} else {
					$_response = array(
						'error' => 'This user does not exist.'
					);
				}
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;
		
		# Search Method
		case 'search' : 
			if ($_mp->valid_api_key($_data->_key)) {
				$query = array(
					'criteria'    => $_data->criteria, 
				 // 'start_date'  => (isset($_data->start_date)  ? null : $_data->start_date),
				 // 'end_date'    => (isset($_data->end_date)    ? null : $_data->start_date),
			 // 'category'    => (isset($_data->category)    ? null : $_data->category),
			 // 'subcategory' => (isset($_data->subcategory) ? null : $_data->subcategory),
				 // 'tag_words'   => (isset($_data->tag_words)   ? null : $_data->tag_words)
				);
				
				$_response = $_mp->article_search($query);
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;
			
		# Fetch Article
		case 'fetch' : 
			if ($_mp->valid_api_key($_data->_key)) {
				$article = $_mp->article_fetch($_data->article_id);
				
				if ($article->article_id) {
					$_response = $article;
				} else {
					$_response = array(
						'error' => 'Article does not exist.'
					);
				}
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;

		# Fetch All Categories
		case 'all_categories' : 
			if ($_mp->valid_api_key($_data->_key)) {
				$_response = $_mp->grab_all_categories();
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;
		
		# Fetch Categories
		case 'categories' : 
			if ($_mp->valid_api_key($_data->_key)) {
				$_response = $_mp->grab_categories();
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;
			
		# Fetch Sub-Categories
		case 'subcategories' : 
			if ($_mp->valid_api_key($_data->_key)) {
				$_response = $_mp->grab_subcategories($_data->category_id);
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;
			
		# Fetch User's Groups
		case 'groups' : 
			if ($_mp->valid_api_key($_data->_key)) {
				$_response = $_mp->my_groups($_data->user_id);
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;
			
		# Post Article
		case 'post' : 
			if ($_mp->valid_api_key($_data->_key)) {
				$article = $_mp->article_post($_data);
				
				if ($article !== false) {
					$_mp->log('fetch', json_encode(array('article_id' => $article)), null, null);
					$_response = $_mp->article_fetch($article);
				} else {
					$_response = array(
						'error' => 'We were unable to post your article.'
					);
				}
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;

    # Deactivate article
    case 'deactivate_article' :
	if ($_mp->valid_api_key($_data->_key)) {
	    if ($_mp->article_deactivate($_data->article_id) === true) {
		$_response = array(
		    'success' => true
		);
	    } else {
		$_response = array(
		    'success' => false
		);
	    }
	} else {
	    $_response = array(
		'error' => 'Invalid API key.'
	    );
	}
	break;
			
		# Increment the Syndications of an Article
		case 'syndicate_plus_one' : 
			if ($_mp->valid_api_key($_data->_key)) {
				if ($_mp->article_increment_syndications($_data->article_id, $_data->user_id)) {
					$_response = array(
						'success' => true
					);
				} else {
					$_response = array(
						'success' => false
					);
				}
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;
			
		# Grab Comments
		case 'grab_comments' : 
			if ($_mp->valid_api_key($_data->_key)) {
				$comments = $_mp->comments_grab($_data->article_id);
				
				if ($comments) {
					$_response = $comments;
				}
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;
			
		# Post Comment
		case 'post_comment' : 
			if ($_mp->valid_api_key($_data->_key)) {
				if ($_mp->comment_post($_data)) {
					$_response = array(
						'success' => true
					);
				} else {
					$_response = array(
						'success' => false
					);
				}
			} else {
				$_response = array(
					'error' => 'Invalid API key.'
				);
			}
			break;
	}
	# Store Response
	$_data->response = $_response;

	# Log Data
	$_mp->log($_data->_method, json_encode($_data));

	# Show JSON Response
	echo(json_encode($_response));
?>
