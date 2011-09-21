#!/usr/bin/perl -w

package JsonRpcParser;
	use strict;
	use lib qw(/home/oneighty/library);
	use MediaPlace;
	use JSON;
	
		my($_180) = MediaPlace->new;
	
		sub new
		{
			my($_class) = shift;
			my($_self)  = {};
				return(bless($_self, $_class));
		}
		
		sub map
		{
			my($_self, $_j);
				return(to_json({
					logon              => 'User Login', 
					search             => 'Article Search', 
					fetch              => 'Grab Article', 
					categories         => 'Grab Category List', 
					subcategories      => 'Grab Subcategory List', 
					groups             => 'Grab User\'s Groups', 
					post               => 'Post Article', 
					syndicate_plus_one => 'Update Article Syndication Statistics', 
					comments_grab      => 'Grab Comments for Article', 
					comments_post      => 'Post Comment to Article', 
					request            => $_j
				}, {
					latin1 => 1, 
					pretty => 1
				}));
		}
		
		sub parse
		{
			my($_self, $_j) = @_;
			my($_json)         = from_json($_j, {
				latin1 => 1,
				pretty => 1
			});
			
			if ($_json->{'_method'}) {
				if ($_json->{'_method'} eq 'logon') {
					return($_self->logon({%{$_json}}));
				}
				
				elsif ($_json->{'_method'} eq 'search') {
					return($_self->search({%{$_json}}));
				}
				
				elsif ($_json->{'_method'} eq 'fetch') {
					return($_self->fetch({%{$_json}}));
				}
				
				elsif ($_json->{'_method'} eq 'categories') {
					return($_self->categories({%{$_json}}));
				}
				
				elsif ($_json->{'_method'} eq 'subcategories') {
					return($_self->subcategories({%{$_json}}));
				}
				
				elsif ($_json->{'_method'} eq 'groups') {
					return($_self->groups({%{$_json}}));
				}
				
				elsif ($_json->{'_method'} eq 'post') {
					return($_self->post({%{$_json}}));
				}
				
				elsif ($_json->{'_method'} eq 'syndicate_plus_one') {
					return($_self->syndicate_plus_one({%{$_json}}));
				}
				
				elsif ($_json->{'_method'} eq 'comments_grab') {
					return($_self->grab_comments({%{$_json}}));
				}
				
				elsif ($_json->{'_method'} eq 'comments_post') {
					return($_self->post_comment({%{$_json}}));
				}
				
				else {
					return($_self->map($_j));
				}
			} else {
				return($_self->map);
			}
			
			sub logon
			{
				my($_self, $_json) = @_;
				my($_uid)          = $_180->user_login($_json->{'username'}, $_json->{'passwd'});
				
				if ($_uid) {
					if (my($_user) = $_180->user_retrieve($_uid)) {
						return(to_json({
							%{$_user}
						}, {
							latin1 => 1, 
							pretty => 1
						}));
					}
				} else {
					return(to_json({
						error => 'Invalid username and or password.'
					}, {
						latin1 => 1, 
						pretty => 1
					}));
				}
			}
			
			sub search
			{
				my($_self, $_json) = @_;
				
				if ($_180->valid_api_key($_json->{'_key'})) {
					my(%_query)    = (
						criteria    => (defined($_json->{'criteria'})    ? $_json->{'criteria'}    : undef), 
						start_date  => (defined($_json->{'start_date'})  ? $_json->{'start_date'}  : undef), 
						end_date    => (defined($_json->{'end_date'})    ? $_json->{'end_date'}    : undef), 
						category    => (defined($_json->{'category'})    ? $_json->{'category'}    : undef), 
						subcategory => (defined($_json->{'subcategory'}) ? $_json->{'subcategory'} : undef), 
						tag_words   => (defined($_json->{'tag_words'})   ? $_json->{'tag_words'}   : undef)
					);
					my($_articles) = $_180->article_search(\%_query);
						return(to_json(\%{
							$_articles
						}));
				} else {
					return(to_json({
						error => 'Invalid API key!'
					}, {
						latin1 => 1, 
						pretty => 1
					}));
				}
			}
			
			sub fetch
			{
				my($_self, %_json) = @_;
				
				if ($_180->valid_api_key($_json{'_key'})) {
					my($_article) = $_180->article_fetch($_json{'article_id'});
					
					if ($_article) {
						return(to_json({
							%{$_article}
						}, {
							latin1 => 1, 
							pretty => 1
						}));
					} else {
						return(to_json({
							error => 'Article does not exist!'
						}, {
							latin1 => 1, 
							pretty => 1
						}));
					}
					
				} else {
					return(to_json({
						error => 'Invalid API key!'
					}, {
						latin1 => 1, 
						pretty => 1
					}));
				}
			}
			
			sub categories
			{
				my($_self, %_json) = @_;
				
				if ($_180->valid_api_key($_json{'_key'})) {
					my($_categories) = $_180->grab_categories;
						return(to_json({
							%{$_categories}
						}, {
							latin1 => 1, 
							pretty => 1
						}))
				} else {
					return(to_json({
						error => 'Invalid API key!'
					}, {
						latin1 => 1, 
						pretty => 1
					}));
				}
			}
			
			sub subcategories
			{
				my($_self, %_json) = @_;
				
				if ($_180->valid_api_key($_json{'_key'})) {
					my($_categories) = $_180->grab_subcategories($_json{'category_id'});
						return(to_json({
							%{$_categories}
						}, {
							latin1 => 1, 
							pretty => 1
						}));
				} else {
					return(to_json({
						error => 'Invalid API key!'
					}, {
						latin1 => 1, 
						pretty => 1
					}));
				}
			}
			
			sub groups
			{
				my($_self, %_json) = @_;
				
				if ($_180->valid_api_key($_json{'_key'})) {
					my($_groups) = $_180->my_groups($_json{'user_id'});
						return(to_json({
							%{$_groups}
						}, {
							latin1 => 1, 
							pretty => 1
						}));
				} else {
					return(to_json({
						error => 'Invalid API key!'
					}, {
						latin1 => 1, 
						pretty => 1
					}));
				}
			}
			
			sub post
			{
				my($_self, %_json) = @_;
				
				if ($_180->valid_api_key($_json{'_key'})) {
					
				} else {
					return(to_json({
						error => 'Invalid API key!'
					}, {
						latin1 => 1, 
						pretty => 1
					}));
				}
			}
			
			sub syndicate_plus_one
			{
				my($_self, %_json) = @_;
				
				if ($_180->valid_api_key($_json{'_key'})) {
					if ($_180->syndicate_plus_one($_json{'article_id'}, $_json{'user_id'})) {
						return(to_json({
							success => 1
						}, {
							latin1 => 1, 
							pretty => 1
						}));
					} else {
						return(to_json({
							success => 0, 
							error   => 'Unable to update statistics at this time!'
						}, {
							latin1 => 1, 
							pretty => 1
						}));
					}
				} else {
					return(to_json({
						error => 'Invalid API key!'
					}, {
						latin1 => 1, 
						pretty => 1
					}));
				}
			}
			
			sub grab_comments
			{
				my($_self, %_json) = @_;
				
				if ($_180->valid_api_key($_json{'_key'})) {
					
				} else {
					return(to_json({
						error => 'Invalid API key!'
					}, {
						latin1 => 1, 
						pretty => 1
					}));
				}
			}
			
			sub post_comment
			{
				my($_self, %_json) = @_;
				
				if ($_180->valid_api_key($_json{'_key'})) {
					
				} else {
					return(to_json({
						error => 'Invalid API key!'
					}, {
						latin1 => 1, 
						pretty => 1
					}));
				}
			}
		}