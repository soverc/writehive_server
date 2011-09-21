#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

# Set Encoding
# use encoding 'latin1', Filter => 1;
use lib('/home/writecrowd/library');

# Declare our Package
package MediaPlace;

# Use Strict Syntax
use strict;

# Use SQL wrapper
use mpSql;

# Use BBCode Encoder
use mpBBCode;

# Use Time
use POSIX qw(strftime);

# Use HTML Entities
use HTML::Entities;

# Use JSON (Must Install)
use JSON;

# Use XML-RPC (Must Install)
use XML::RPC;

# Use Scalar Utilities
use Scalar::Util('looks_like_number');

# Use Net SMTP
use Net::SMTP_auth;

# Declare global SQL
our($_sql) = mpSql->new;

	# Connect to the MySQL Server
 	$_sql->connect('mysql', '10.179.168.196', 'mpdb', 'mpFj8*Qm159788', 'mediaplace');

# Declare global BBCode
my($_bbc) = mpBBCode->new;

# Declare JSON Instance
my($_json) = JSON->new;

# Generates an instance of the class
sub new
{	
	# Create the class instance
	my($_class) = @_;
	
	# Store the class
	my($_self)  = {};
return(bless($_self, $_class));
}

# Tests the class
sub ping
{
	my($_self) = @_;
	my($_time) = POSIX::strftime('%H:%M On %b %d, %Y', localtime());
		return('{"success":true, "time":"'.$_time.'"}');
}

# Generates Unique User Account Keys
sub keygen
{
	my($_self)  = @_;
	my(@_chars) = ('A' .. 'Z', 0 .. 9);
	my($_key);
	
	# First Pass
	foreach (1 .. 5) {
		$_key .= $_chars[rand @_chars];
	}
	
	# Second Pass
	$_key .= '-';
	
	foreach (1 .. 5) {
		$_key .= $_chars[rand @_chars];
	}
	
	# Final Pass
	$_key .= '-';
	
	foreach (1 .. 5) {
		$_key .= $_chars[rand @_chars];
	}
	
	# See if the key already exists
	return($_key);
}

# User Registration
sub user_create
{
	my($_self, $_usrdata) = @_;
	
	if ($_sql->insert('users', \%{$_usrdata})) {
		my($_newuser) = $_sql->query("SELECT id FROM users WHERE display_name = '".$_usrdata->{'display_name'}."'");
			return(@$_newuser[0]->{'id'});
	} else {
		return(0);
	}
}

# User Update
sub user_update
{
	my($_self, $_userdata, $_id) = @_;
	my(@_args)                   = ('id = '.$_id);
	
	if ($_sql->update('users', \%{$_userdata}, \@_args, undef)) {
		return(1);
	} else {
		return(0);
	}
}

# Username Validator
sub display_name_validation
{
	my($_self, $_uname) = @_;
	my(@_fields)        = ('display_name');
	my(@_args)          = ("display_name = '$_uname'");
	my($_valid)         = $_sql->select('users', \@_fields, \@_args, undef);
	
	if (scalar(@$_valid)) {
		return(1);
	} else {
		return(0);
	}
}

# Grab Existing Usernames
sub existing_users
{
	my($_self) = shift;
		return($_sql->query("SELECT display_name FROM users"));
}

# User Login
sub user_login
{
	my($_self, $_username, $_passwd)  = @_;
	my(@_fields)                      = ('id');
	my(@_args)                        = ("display_name = '".$_username."'", "passwd = PASSWORD('".$_passwd."')", "active = '1'");
	my($_users)                       = $_sql->select('users', \@_fields, \@_args, undef);
	
	if (scalar(@$_users)) {
		return(@$_users[0]->{id});
	} else {
		return(0);
	}
}


# Grab User Information
sub user_retrieve
{
	my($_self, $_uid) = @_;
	
	if (defined($_uid)) {
		my(@_fields) = ('*');
		my(@_args) = ("id = ".$_uid);
		my($_user) = $_sql->select('users', \@_fields, \@_args, undef);
		
		if (scalar(@$_user)) {
			my($_revenue)      = $_sql->query("SELECT SUM(`amount`) AS `total_revenue` FROM `invoices` WHERE `author_id` = ".@$_user[0]->{'id'}." AND `invoice_type` = 'article'");
			my($_articles)     = $_sql->query("SELECT COUNT(`id`) AS `total_articles` FROM `articles` WHERE `author_id` = ".@$_user[0]->{'id'});
			my($_comments)     = $_sql->query("SELECT COUNT(`id`) AS `total_comments` FROM `comments` WHERE `author_email` = '".@$_user[0]->{'email_address'}."'");
			my($_syndications) = $_sql->query("SELECT COUNT(`uid`) AS `total_syndications` FROM `syndicated` WHERE `uid` = ".@$_user[0]->{'id'});
			
			if (@$_revenue[0]->{'total_revenue'}) {
				@$_user[0]->{'revenue'} = (@$_revenue[0]->{'total_revenue'} * 0.90);
			} else {
				@$_user[0]->{'revenue'} = 0.00;
			}
			
			@$_user[0]->{'articles'}      = @$_articles[0]->{'total_articles'};
			@$_user[0]->{'comments'}      = @$_comments[0]->{'total_comments'};
			@$_user[0]->{'syndications'}  = @$_syndications[0]->{'total_syndications'};
			@$_user[0]->{'user_articles'} = $_self->user_articles(@$_user[0]->{'id'});
				delete(@$_user[0]->{'passwd'});
					return(@$_user[0]);
		} else {
			return(0);
		}
	}
}

sub user_retrieve_public_profile
{
	my($_self, $_uid) = @_;
	
	if (defined($_uid)) {
		my(@_fields) = (
			'id', 
			'display_name', 
			'first_name', 
			'last_name', 
			'email_address', 
			'street_address', 
			'city', 
			'state', 
			'zip_code', 
			'date_of_birth', 
			'gender', 
			'paypal', 
			'account_key', 
			'date_created', 
			'date_updated', 
			'role', 
			'bio', 
			'display_pic'
		);
		my(@_args) = ("display_name = '".$_uid."'");
		my($_user) = $_sql->select('users', \@_fields, \@_args, undef);
		
		if (scalar(@$_user)) {
			my($_revenue)      = $_sql->query("SELECT SUM(`amount`) AS total_revenue` FROM `invoices` WHERE `author_id` = ".@$_user[0]->{'id'}." AND `invoice_type` = 'article'");
			my($_articles)     = $_sql->query("SELECT * FROM `articles` WHERE `author_id` = ".@$_user[0]->{'id'});
			my($_comments)     = $_sql->query("SELECT * FROM `comments` WHERE `author_email` = '".@$_user[0]->{'email_address'}."'");
			my($_syndications) = $_sql->query("SELECT * FROM `syndicated` WHERE `uid` = ".@$_user[0]->{'id'});
			
			if (@$_user[0]->{'founders_club_id'} == 0) {
				@$_user[0]->{'revenue'} = (@$_revenue[0]->{'total_revenue'} * 0.70);
			} else {
				@$_user[0]->{'revenue'} = (@$_revenue[0]->{'total_revenue'} * 0.90);
			}
			
			@$_user[0]->{'articles'}      = scalar(@$_articles);
			@$_user[0]->{'comments'}      = scalar(@$_comments);
			@$_user[0]->{'syndications'}  = scalar(@$_syndications);
			@$_user[0]->{'user_articles'} = $_self->user_articles(@$_user[0]->{'id'});
				return(@$_user[0]);
		} else {
			return(0);
		}
	}
}

# Grab Articles Created By User
sub user_articles
{
	my($_self, $_uid) = @_;
	my($_q)           = 'SELECT `a`.*, `c`.label AS `cat_label`, `d`.`label` AS `secondcat_label`, `s`.`label` AS `subcat_label`, `t`.`label` AS `secondsubcat_label` FROM `articles` AS `a` LEFT JOIN `categories` AS `c` ON (`c`.`id` = `a`.`category_id`) LEFT JOIN `categories` AS `d` ON (`d`.`id` = `a`.`secondcategory_id`) LEFT JOIN `subcategories` AS `s` ON (`s`.`id` = `a`.`subcategory_id`) LEFT JOIN `subcategories` AS `t` ON (`t`.`id` = `a`.`secondsubcategory_id`) WHERE `a`.`author_id` = '.$_uid;
	my($_articles)    = $_sql->query($_q);

	if (scalar(@$_articles)) {	
		
		for (my($_i) = 0; $_i < scalar(@$_articles); $_i ++) {
			@$_articles[$_i]->{'comments'}     = $_self->article_comments(@$_articles[$_i]->{'id'});
			@$_articles[$_i]->{'syndications'} = $_self->article_syndications(@$_articles[$_i]->{'id'});
			@$_articles[$_i]->{'purchases'}    = $_self->article_purchases(@$_articles[$_i]->{'id'});
			@$_articles[$_i]->{'views'}        = $_self->article_views(@$_articles[$_i]->{'id'});
		}
		return($_articles);
	} else {
		return(0);
	}
}

# Optimized user_articles, written by Tim Davis on 8/9/11
sub user_articles2
{
	my($_self, $_uid) = @_;
	my($_q)           = 'SELECT * FROM v_user_article_stats WHERE author_id = '.$_uid;
	my($_articles)    = $_sql->query($_q);

    if (scalar(@$_articles)) { return ($_articles); }
    else { return(0); }
}

# States
sub grab_states
{
	my($_self)   = shift;
		return($_sql->query("SELECT * FROM state_lookup ORDER BY name ASC"));
}

# Countries
sub grab_countries
{
	my($_self)   = shift;
		return($_sql->query('SELECT * FROM country_lookup ORDER BY name ASC'));
}

# Genders
sub grab_genders
{
	my($_self) = shift;
		return {
			Male   => 1,
			Female => 0
		};
}

# Article Categories
sub grab_categories
{
	my($_self) = @_;
		return($_sql->query("SELECT * FROM categories WHERE active = 1 ORDER BY `order` ASC"));
}

# Grab All Categories
sub grab_all_categories
{
	my($_self) = @_;
		return($_sql->query("SELECT * FROM categories ORDER BY `order` ASC"));
}

# Article SubCategories
sub grab_subcategories
{
	my($_self, $_cid) = @_;
		return($_sql->query("SELECT * FROM subcategories WHERE category_id = '$_cid' ORDER BY label ASC"));
		
}

# Article Posting
sub article_post
{
	my($_self, $_data) = @_;
		$_data->{'content'} = encode_entities($_data->{'content'});
		return($_sql->insert('articles', \%{$_data}));
}

# Update an Article
sub article_update
{
	my($_self, $_id, $_content) = @_;
	my(@_fields)                = ('content');
	my(@_args)                  = ('id = '.$_id);
	my($_article)               = $_sql->select('articles', \@_fields, \@_args, undef);
	my($_ccontent)              = @$_article[0]->{'content'};
	
	# Encode the new Content
	$_content = $_bbc->encode('<br /><br /><hr />UPDATE<hr /><br />'.$_content);
	
	# Put all the Content together
	$_content = $_ccontent.$_content;
	
	my(%_data) = (
		'content'       => $_content,
		'last_modified' => 'NOW()'
	);
	
	# Save the Data
	if ($_sql->update('articles', \%_data, \@_args, undef)) {
		return(1);
	} else {
		return(0);
	}
}

# Delete Article
sub article_delete
{
	my($_self, $_id) = @_;
	
	if ($_sql->query("DELETE FROM articles WHERE id = $_id")) {
		return(1);
	} else {
		return(0);
	}
}

# Grab an Article
sub article_fetch
{
	my($_self, $_aid) = @_;
	my($_article)     = $_sql->query('SELECT a.*, u.display_name AS author_name, c.label AS cat_label, t.label AS secondcat_label FROM articles a INNER JOIN users u ON (u.id = a.author_id) INNER JOIN categories c ON (c.id = a.category_id) INNER JOIN categories t ON (t.id = a.secondcategory_id) WHERE a.id = '.$_sql->quote($_aid));
	
	if (scalar(@$_article) == 1) {
		return(@$_article[0]);
	} else {
		return(0);
	}
}

# Grab an Article by its Body
sub article_fetch_by_body
{
	my($_self, $_content) = @_;
	my($_article)         = $_sql->query("SELECT id FROM articles WHERE content = ".$_sql->quote($_content));
	
	if (scalar(@$_article) == 1) {
		return(@$_article[0]->{'id'});
	} else {
		return(0);
	}
}

# Article Search
sub article_search
{
	my($_self, $_query) = @_;
	my($_q) = 'SELECT a.*, c.label AS cat_label, d.label AS secondcat_label, s.label AS subcat_label, t.label AS secondsubcat_label, u.display_name FROM articles a LEFT JOIN categories c ON (c.id = a.category_id) LEFT JOIN categories d ON (d.id = a.secondcategory_id) LEFT JOIN subcategories s ON (s.id = a.subcategory_id) LEFT JOIN subcategories t ON (t.id = a.secondsubcategory_id) INNER JOIN users u ON (u.id = a.author_id) WHERE a.title LIKE '.$_sql->quote('%'.$_query->{criteria}.'%').' OR a.content LIKE '.$_sql->quote('%'.$_query->{criteria}.'%').' OR a.description LIKE '.$_sql->quote('%'.$_query->{criteria}.'%').' OR a.tag_words LIKE '.((defined($_query->{tag_words})) ? $_sql->quote('%'.$_query->{tag_words}.'%') : $_sql->quote('%'.$_query->{criteria}.'%'));
	
	if (($_query->{start_date} ne undef) and ($_query->{end_date} ne undef)) {
		$_q .= ' OR (a.date_created BETWEEN '.$_sql->quote($_query->{start_date}).' AND '.$_sql->quote($_query->{end_date}).')';
	}
	
	elsif ($_query->{start_date} ne undef) {
		$_q .= ' OR (a.date_created >= '.$_sql->quote($_query->{start_date}).')';
	}
	
	elsif ($_query->{end_date} ne undef) {
		$_q .= ' OR (a.date_created <= '.$_sql->quote($_query->{end_date}).')';
	}
	
	if ($_query->{category} ne undef) {
		$_q .= ' AND a.category_id = '.$_query->{category};
	}
	
	if ($_query->{secondcategory} ne undef) {
		$_q .= ' AND s.id = '.$_query->{secondcategory};
	}

	$_q .= ' AND a.active = 1';
	
	if (my($_articles) = $_sql->query($_q)) {
		for (my($_i) = 0; $_i < scalar(@$_articles); $_i ++) {
			@$_articles[$_i]->{'content'}      = $_self->article_desanitize(@$_articles[$_i]->{'content'});
			@$_articles[$_i]->{'comments'}     = $_self->article_comments(@$_articles[$_i]->{'id'});
			@$_articles[$_i]->{'syndications'} = $_self->article_syndications(@$_articles[$_i]->{'id'});
			@$_articles[$_i]->{'purchases'}    = $_self->article_purchases(@$_articles[$_i]->{'id'});
			@$_articles[$_i]->{'views'} = $_self->article_views(@$_articles[$_i]->{'id'});
		}
		return($_articles);
	} else {
		return(0);
	}
}

sub article_sanitize
{
	my($_self, $_content) = @_;
	$_content             = encode_entities($_content);
		return($_content);
}

sub article_desanitize
{
	my($_self, $_content) = @_;
	$_content             = decode_entities($_content);
		return($_content);
}

sub article_comments
{
	my($_self, $_article) = @_;
	my($_comments)        = $_sql->query("SELECT COUNT(article_id) AS comment_count FROM comments WHERE article_id = ".$_sql->quote($_article));
return(@$_comments[0]->{'comment_count'});
}

sub article_syndications
{
	my($_self, $_article) = @_;
	my($_syndications)    = $_sql->query("SELECT COUNT(aid) AS syndication_count FROM syndicated WHERE aid = ".$_sql->quote($_article));
return(@$_syndications[0]->{'syndication_count'});
}

sub article_purchases
{
	my($_self, $_article) = @_;
	my($_purchases)       = $_sql->query("SELECT COUNT(article_id) AS purchase_count FROM invoices WHERE article_id = ".$_sql->quote($_article));
return(@$_purchases[0]->{'purchase_count'});
}

sub article_views
{
	my($_self, $_article) = @_;
	my($_views)           = $_sql->query("SELECT COUNT(entity_id) AS view_count FROM views WHERE entity_id = ".$_sql->quote($_article)." AND entity_type = 'article'");
return(@$_views[0]->{'view_count'});
}

sub syndicate_plus_one
{
	my($_self, $_article, $_user) = @_;
	
	if ($_sql->query("INSERT INTO syndicated (uid, aid, syndicated) VALUES ('".$_user."', '".$_article."', NOW())")) {
		return(1);
	} else {
		return(0);
	}
}

sub feed_articles_posted
{
	my($_self, $_key) = @_;
	my($_uid)         = $_sql->query("SELECT id FROM users WHERE account_key = '".$_key."'");
	my($_articles)    = $_sql->query(
		"SELECT a.*, c.label AS category, s.label AS secondcategory, u.display_name FROM articles a INNER JOIN categories c ON (c.id = a.category_id) INNER JOIN categories s ON (s.id = a.secondcategory_id) ".
		"INNER JOIN users u ON (u.id = a.author_id) WHERE author_id = '".@$_uid[0]->{'id'}."'"
	);
		return(\@$_articles);
}

sub feed_article_for_syndication
{
	my($_self, $_articleId) = @_;
	my($_article)           = $_sql->query(
		"SELECT a.*, c.label AS category, s.label AS secondcategory, u.display_name AS author_name FROM articles a INNER JOIN categories c ON (c.id = a.category_id) ".
		"INNER JOIN categories s ON (s.id = a.secondcategory_id) INNER JOIN users u ON (u.id = a.author_id) WHERE ".
		(looks_like_number($_articleId) ? "a.id = $_articleId" : "a.name = '$_articleId'")
	);
	
	if (scalar(@$_article)) {
		@$_article[0]->{'content'} = $_bbc->decode(@$_article[0]->{'content'});
			return(@$_article[0]);
	} else {
		return(0);
	}
}

sub feed_article
{
	my($_self, $_article, $_uri,$_username, $_passwd) = @_;
	my($_rpcpath)                                     = 'wp-content/plugins/oneighty/xml/rpc.php';
	$_uri                                             = ((substr($_uri, -1, 1) eq '/') ? $_uri.$_rpcpath : $_uri.'/'.$_rpcpath);
	my($_client)                                      = XML::RPC->new('http://wordpress.travismbrown.com/wp-content/plugins/oneighty/xml/rpc.php');
    my(@_arguments)                                   = ();
    
    if ($_client->call('oneighty.push', {$_username, $_passwd, \%{$_article}})) {
   		return(1);
    } else {
    	return(0);
    }
}

sub grab_comments_by_article
{
	my($_self, $_id) = @_;
	my($_comments)   = $_sql->query("SELECT * FROM comments WHERE article_id = $_id");
	
	if (scalar(@$_comments)) {
		return($_comments);
	} else {
		return(0);
	}
}

sub add_comment
{
	my($_self, $_comment) = @_;
	
	if ($_sql->insert('comments', \%{$_comment})) {
		return(1);
	} else {
		return(0);
	}
}

sub feed_get
{
	my($_self, $_uri,$_username, $_passwd) = @_;
}

sub valid_api_key
{
	my($_self, $_key) = @_;
	my($_validation)  = $_sql->query("SELECT account_key FROM users WHERE account_key = '".$_key."'");
	
	if (scalar(@$_validation) == 1) {
		return(1);
	} else {
		return(0);
	}
}

sub ping_xmlrpc
{
	my($_self)   = @_;
	my($_client) = XML::RPC->new('http://www.foldingmedia.com/feeds/xmlrpc');
	
	return($_client->call('180.ping', 123, 'hash'));
}

sub ds_store
{
	my($_self, $_data) = @_;
	my(%_info)         = (
		data    => $_data,
		created => 'NOW()'
	);
	
	if ($_sql->insert('ds_credit_store', \%_info)) {
		return(1);
	} else {
		return(0);
	}
}

sub grab_external_credits
{
	my($_self, $_token) = @_;
	my($_user)          = $_sql->query("SELECT id, name, email, url, service, token FROM external_credit_store WHERE token = '".$_token."' AND active = 1");
return($_user);
}

sub add_to_invites
{
	my($_self, $_data)        = @_;
	my($_q)                   = "INSERT IGNORE INTO people_to_invite ";
	
	if ($_data->{'category_id'}) {
		$_q .= "(email_address, category_id, created) VALUES (".$_sql->quote($_data->{'email_address'}).", ".$_sql->quote($_data->{'category_id'}).", NOW())";
	} else {
		$_q .= "(email_address, other_id, created) VALUES (".$_sql->quote($_data->{'email_address'}).", ".$_sql->quote($_data->{'other_id'}).", NOW())";
	}
	
	if ($_sql->query($_q)) {
		return(1);
	} else {
		return(0);
	}
}

sub create_group
{
	my($_self, $_data) = @_;
		return($_sql->insert('groups', \%{$_data}));
}

sub update_group
{
	my($_self, $_data, $_gid) = @_;
	my(@_args)                = ('id = '.$_gid);
	
	if ($_sql->update('groups', \%{$_data}, \@_args, undef)) {
		return(1);
	} else {
		return(0);
	}
}

sub group_search
{
	my($_self, %_args) = @_;
	my($_q)            = 'SELECT g.*, u.display_name, c.label as cat_label, s.label as scat_label FROM groups g INNER JOIN users u ON (u.id = creator) INNER JOIN categories c ON (c.id = g.category) INNER JOIN subcategories s ON (s.id = g.subcategory) WHERE ';
	
	if (defined($_args{'criteria'})) {
		$_q .= "name LIKE '%".$_args{'criteria'}."%' OR description LIKE '%".$_args{'criteria'}."%' OR taga LIKE '%".$_args{'criteria'}."%' OR tagb LIKE '%".$_args{'criteria'}."%'";
	} else {
		if ($_args{'subcategory'} ne '') {
			$_q .= "category = '".$_args{'category'}."' AND subcategory = '".$_args{'subcategory'}."'";
		} else {
			$_q .= "category = '".$_args{'category'}."'";
		}
	}
	$_q               .= " AND listed = '1'";
	my($_results)      = $_sql->query($_q);
	
	if (scalar(@$_results)) {
		my($_a);
	
		for my $_result (@$_results) {
			$_a                    = $_sql->query("SELECT COUNT(id) AS article_count FROM articles WHERE group_id = '".$_result->{'id'}."'");
			$_result->{'articles'} = @$_a[0]->{'article_count'};
		}
	}
	
	return($_results);
}

sub my_groups
{
	my($_self, $_user) = @_;
	my($_owned)        = $_sql->query("SELECT * FROM groups WHERE creator = '".$_user."'");
	my($_joined)       = $_sql->query("SELECT j.*, g.* FROM group_members j INNER JOIN groups g ON (j.gid = g.id) WHERE uid = '".$_user."'");
	my(@_all);	
		
		push(@_all,$_owned);
		push(@_all, $_joined);
		
			return{
				owned  => $_owned, 
				joined => $_joined, 
				all    => @_all
			};
}

sub grab_groups
{
	my($_self) = shift;
		return($_sql->query('SELECT g.*, u.display_name FROM groups g INNER JOIN users u ON (u.id = g.creator)'));
}

sub grab_groups_for_join
{
	my($_self, $_name) = @_;
		return($_sql->query("SELECT g.*, u.display_name FROM groups g INNER JOIN users u ON (u.id = g.creator) WHERE name LIKE '%".$_name."%' AND listed = 1"));
}

sub grab_group
{
	my($_self, $_id) = @_;
	my($_group)      = $_sql->query("SELECT * FROM groups WHERE id = '".$_id."'");
		return(@$_group[0]);
}

sub grab_group_by_name
{
	my($_self, $_name) = @_;
	my($_group)        = $_sql->query("SELECT * FROM groups WHERE name = '".$_name."'");
		return(@$_group[0]);
}

sub grab_group_members
{
	my($_self, $_gid) = @_;
	my($_members)     = $_sql->query("SELECT g.*, u.display_name FROM group_members g INNER JOIN users u ON (u.id = g.uid) WHERE gid = ".$_gid);
		return($_members);
}

sub grab_group_applicants
{
	my($_self, $_gid)  = @_;
	my($_applications) = $_sql->query("SELECT a.*, u.display_name FROM group_applications a INNER JOIN users u ON (u.id = a.uid) WHERE gid = ".$_gid);
		return($_applications);
}

sub group_invite
{
	my($_self, $_args)  = @_;
	my(@_chars)         = ('A' .. 'Z', 'a' .. 'z', 0 .. 9, '=');
	my($_name)          = $_sql->query("SELECT name FROM groups WHERE id = '".$_args->{'group'}."'");
	$_name              = @$_name[0]->{'name'};
	my($_token);
	my($_email);
	
	foreach (1 .. 25) {
		$_token .= $_chars[rand @_chars];
	}
	
	if (defined($_args->{'uid'})) {
		$_email = $_sql->query("SELECT email_address FROM users WHERE id = '".$_args->{'user'}."'");
		$_email = @$_email[0]->{'email_address'};
		$_sql->query("INSERT INTO group_invites (token, gid, uid, used, created) VALUES ('".$_token."', '".$_args->{'group'}."', '".$_args->{'user'}."', '".$_email."', 0, NOW())");
	} else {
		$_email = $_args->{'email'};
		$_sql->query("INSERT INTO group_invites (token, gid, email, used, created) VALUES ('".$_token."', '".$_args->{'group'}."','".$_email."',  0, NOW())");
	}
	
	$_self->mail(
			$_email, 
			'MediaPlace Group Invitation', 
			"You have been invited to join the ".$_name." Group at 180 Create. \nTo accept this invitation please follow the link below.\n\"https://www.180create.com/join-group.pl?group=".$_name."&token=".$_token."\n\nSincerely,\n180 Create Team"
	);
return($_token);
}

sub join_group
{
	my($_self, $_args) = @_;
		$_sql->query("INSERT INTO group_members (uid, gid, joined) VALUES (".$_sql->quote($_args->{'user'}).", ".$_sql->quote($_args->{'group'}).", NOW())");
}

sub apply_to_join_group
{
	my($_self, $_args) = @_;
		if ($_sql->query("INSERT INTO group_applications (gid, uid, applied) VALUES (".$_sql->quote($_args->{'group'}).", ".$_sql->quote($_args->{'user'}).", NOW())")) {
			my($_group)     = $_self->grab_group($_args->{'group'});
			my($_owner)     = $_self->user_retrieve($_group->{'creator'});
			my($_applicant) = $_self->user_retrieve($_args->{'user'});
			
			$_self->mail(
				$_owner->{'email_address'}, 
				"User Has Requested to Join Your Group (".$_group->{'name'}.")",
				"Dear ".$_owner->{'display_name'}.", \n\n".$_applicant->{'display_name'}." just applied to join your group (".$_group->{'name'}.")\nYou may login to accept or deny their application.\n\nSincerely, 180 Create Team"
			);
			
			$_self->mail(
				$_applicant->{'email_address'}, 
				"You just requested to join the ".$_group->{'name'}." Group", 
				"Dear ".$_applicant->{'display_name'}.", \n\nYou just applied to join the ".$_group->{'name'}." owned by ".$_owner->{'display_name'}.".  We have notified ".$_owner->{'display_name'}." and they will accept or deny your application shortly.\n\nSincerely, 180 Create Team"
			);
			return(1);
  		} else {
  			return(0);
  		}
}

sub remove_user_from_group
{
	my($_self, $_gid, $_uid) = @_;
		if ($_sql->query("DELETE FROM group_members WHERE gid = ".$_gid." AND uid = ".$_uid)) {
			return(1);
		} else {
			return(0);
		}
}

sub manage_application
{
	my($_self, $_gid, $_uid, $_aid, $_accepted) = @_;
	my($_group)                                 = $_self->grab_group($_gid);
	my($_applicant)                             = $_self->user_retrieve($_uid);
	my($_message)                               = "Dear ".$_applicant->{'display_name'}.", \n\n";
	
	if ($_accepted) {
		if ($_self->join_group({user => $_uid, group => $_gid})) {
			$_message .= "Your application to join the ".$_group->{'name'}." has just been accepted!";
		} else {
			return(0);
		}
	} else {
		$_message .= "Your application to join the ".$_group->{'name'}." has been denied.";
	}
	
	$_message .= "\n\nSincerely, 180 Create Team";
	
	if ($_sql->query("DELETE FROM group_applications WHERE aid = ".$_aid)) {
		if ($_self->mail(
			$_applicant->{'email_address'}, 
			"Regarding you application to join the ".$_group->{'name'}." Group", 
			$_message
		)) {
			return(1);
		}
	} else {
		return(0);
	}
}

sub mail
{
	my($_self, $_to, $_subject, $_body) = @_;
	# $_to                                = s/\@/\\\@/g;
	my($_mail)                          = "MIME-Version: 1.0\n";
    	$_mail                             .= "From: 180 Create <info\@180create.com>\n";
    	$_mail                             .= "To: ".$_to."\n";
	$_mail                             .= "Date: ".localtime()."\n";
    	$_mail                             .= "Subject: ".$_subject."\n\n";
    	$_mail                             .= $_body; 
    	my($_smtp)                          = Net::SMTP_auth->new('secure.emailsrvr.com', Debug => 0, Port => 465);
					
		# Authorize the user
		$_smtp->auth('LOGIN', 'info@180create.com', 'Launch1010');
						
		# Who's it from
		$_smtp->mail('info@180create.com');
						
		# Set the Recipient
		$_smtp->recipient($_to);
					
		# Message Details
		$_smtp->data($_mail);
					
		# Close the Connection
		$_smtp->quit();
	
		# Log Message
		$_self->log_message({
			to        => $_to, 
			from      => 'info@180create.com', 
			subject   => $_subject, 
			message   => $_body 
		});
}

sub contact
{
	my($_self, $_to, $_from, $_subject, $_body) = @_;
	my($_mail)                          = "MIME-Version: 1.0\n";
    	$_mail                             .= $_from."\n";
    	$_mail                             .= "To: ".$_to."\n";
    	$_mail                             .= "Date: ".localtime()."\n";
    	$_mail                             .= "Subject: ".$_subject."\n\n";
    	$_mail                             .= $_body; 
    	my($_smtp)                          = Net::SMTP_auth->new('180creations.com',  Debug => 1, Port => 25);
					
		# Authorize the user
		$_smtp->auth('LOGIN', 'info@180creations.com', 'Launch1010');
					
		# Who's it from
		$_smtp->mail($_from);
					
		# Set the Recipient
		$_smtp->recipient($_to);
					
		# Message Details
		$_smtp->data($_mail);
					
		# Close the Connection
		$_smtp->quit();
	
		# Log Message
		$_self->log_message({
			to        => $_to, 
			from      => $_from, 
			subject   => $_subject, 
			message   => $_body
		});
}

sub log_message
{
	my($_self, $_data) = @_;
	$_data->{'to'}     =~ s/@/\\@/g;
	$_data->{'from'}   =~ s/@/\\@/g;
	
	my($_query)        = "INSERT INTO `message_log` (`to`, `from`, `subject`, `message`, `timestamp`) VALUES ('".$_data->{'to'}."', '".$_data->{'from'}."', '".$_data->{'subject'}."', '".$_data->{'message'}."', NOW())";
	
	if ($_sql->query($_query)) {
		return(1);
	} else {
		return(0);
	}
}

# Return Class Status
1;
