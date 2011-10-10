<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title><?php echo Cgn_Template::getPageTitle();?></title>
<link rel="stylesheet" href="<?php cgn_templateurl();?>css/960/reset.css" />
<link rel="stylesheet" href="<?php cgn_templateurl();?>css/960/text.css" />
<link rel="stylesheet" href="<?php cgn_templateurl();?>css/960/960.css" />
<link rel="stylesheet" href="<?php echo cgn_url();?>media/shared_css/form.css" />
<link rel="stylesheet" href="<?php echo cgn_url();?>media/shared_css/system.css" />

<link rel="stylesheet" href="<?php cgn_templateurl();?>css/style02.css" />
</head>
<body>
<div class="container_12" id="site_wrapper">
	<div class="grid_12 nav_top">
		<div class="grid_1 prefix_1 alpha">
			<?php if ($u->isAnonymous() ): ?>
				<a href="<?php echo cgn_url();?>">home</a>
			<?php else: ?>
				<a href="<?php echo cgn_sappurl('whv', 'dashboard');?>">home</a>
			<?php endif; ?>

		</div>
		<div class="grid_1">
			<a href="<?php echo cgn_url();?>blog">blog</a>
		</div>
		<div class="grid_1">
			<a href="<?php echo cgn_url();?>main.page/about_us.html">about</a>
		</div>
		<div class="grid_1">
			&nbsp;
		</div>


		<div class="grid_4 prefix_2 omega nav_login" style="float:right;">
		<?php if ($u->isAnonymous() ): ?>

			<form action="<?php echo cgn_appurl('login', 'main', 'login');?>" method="post" style="width:100%;">

			<input type="text"     size="12"  name="email">
				&nbsp;
			<input type="password" size="12"  name="password">
				&nbsp;

			<input class="color_1" type="submit"   value="Sign-In" size="12">
			</form>
			
			<?php else: ?>
				<span class="nav_logout">
				<a href="<?=cgn_appurl('login','main','logout');?>">Not <?=$u->getDisplayName();?>? Sign-out</a>&nbsp;|&nbsp;
				<a href="<?=cgn_appurl('account');?>">Account Settings</a>
				</span>
			<?php endif; ?>

		</div>
		</div>

		<div class="grid_12 logo_banner alpha omega">
			<div class="grid_2 prefix_1 alpha">
				<img src="<?php echo cgn_templateurl();?>images/writehive_logo_sm2.png"/>
			</div>
			<div class="grid_2 prefix_6">
				<input class="color_2" type="button"   value="Get the Plugin" size="12" style="margin-top:1em;" onclick="document.location = '#signup';">
			</div>
		</div>




	<div class="grid_12 omega logo_center">
	<div class="roundedcornr_box_759553">
		<div class="roundedcornr_top_759553"><div class="roundedcornr_sub_759553"></div></div>
		<div class="roundedcornr_content_759553">

		<div class="grid_5 alpha" style="margin-top:10px;margin-left:40px;">
			<div class="">
			<span style="font-weight:bold;">
			The Community that</span>

			<br/>
			<span style="font-weight:bold;">
			Empowers Content</span>
			</div>

			<br/>
			<span style="font-size:14pt;line-height:18pt;">
			At WriteHive we beleive that sharing your work should be easy and that discovering great content should be just as easy.
			<br/>
			</span>
		</div>

		<div class="grid_6 omega" style="margin-top:-50px;">

			<div style="height: 300px; width: 480px; border:1px solid #333;">
				<object style="height: 300px; width: 480px">
				    
				<param name="movie" value="http://www.youtube.com/v/sXCip7UWvFg?version=3">
				    
				<param name="allowFullScreen" value="true"><param name="allowScriptAccess" value="always">

				<embed src="http://www.youtube.com/v/sXCip7UWvFg?version=3" type="application/x-shockwave-flash" allowfullscreen="true" allowScriptAccess="always" 
				width="480" height="300">

				</object>

			</div>

		</div>




<!--
		<div style="clear:left;"></div>
-->
		</div>

		<div class="roundedcornr_bottom_759553"><div class="roundedcornr_sub_759553"></div></div>
	</div>


	</div>

<!--
 	<div class="grid_12 omega logo_center">
		<div class="grid_5 alpha" style="margin-top:10px;margin-left:40px;">
			<div class="">
			<span style="font-weight:bold;">
			The Community that</span>

			<br/>
			<span style="font-weight:bold;">
			Empowers Content</span>
			</div>

			<br/>
			<span style="font-size:14pt;line-height:18pt;">
			At WriteHive we beleive that sharing your work should be easy and that discovering great content should be just as easy.
			<br/>
			</span>
		</div>

		<div class="grid_6 omega" style="margin-top:-40px;">

			<div style="height: 300px; width: 480px; border:1px solid #333;">
	<object style="height: 300px; width: 480px">
	    
	<param name="movie" value="http://www.youtube.com/v/sXCip7UWvFg?version=3">
	    
	<param name="allowFullScreen" value="true"><param name="allowScriptAccess" value="always">

	<embed src="http://www.youtube.com/v/sXCip7UWvFg?version=3" type="application/x-shockwave-flash" allowfullscreen="true" allowScriptAccess="always" 
	width="480" height="300">

	</object>

			</div>

		</div>


	</div>
-->

 	<div class="grid_12 alpha content_boxes">
		<br/>
	</div>

 	<div class="grid_12 alpha content_boxes">
		<div class="grid_2 prefix_2">
			<span class="hdr">Worry Free</span>
			<br/>
			Our Plugin removes the possibility that someone 
			will omit your attribution and backlinks.
		</div>
		<div class="grid_2">
			<span class="hdr">Get Paid</span>
			<br/>
			... or not.  Pricing of your content is up to you.
			Are you looking to get noticed or add 
			another revenue stream to your online presence?
		</div>
		<div class="grid_2">
			<span class="hdr">We're Listening</span>
			<br/>
			We're in a constant dialog with our users to 
			refine our search algorithms and add new features.
			Getting you the most quality content without all the
			noise is our goal.
			
		</div>
		<div class="grid_2 omega">
			<span class="hdr">It's Easy</span>
			<br/>
			The WordPress plugin is simple to install, 
			and simple to use.  Write an article, set a category, 
			and click to share your opinions with the world.
		</div>



	</div>


	<div class="clear"></div>

	<div class="grid_8 prefix_2 suffix_2 content_front_form">


<a name="signup"></a>
				<div class="form-wrapper reg_form" style="width:100%;">
<span class="form-title">Register to Get the Plugin <img src="<?php cgn_templateurl();?>images/wordpress-logo-notext-rgb.png" height="36" valign="middle"/></span>
<div class="form-container reg_form">
<form class="form-form" method="POST" name="reg_form" id="reg_form" action="http://hayley.metrofindings.com:8090/login.register.save/" >
<dl><dt class="first form_req"><label for="email">Email</label></dt>
	<dd class="first form_req"><input type="text" name="email" id="email" size="30" value="" /></dd>
<dt class="form_req"><label for="password">Password</label></dt>
	<dd class="form_req"><input type="password" name="password" id="password" size="30" value="" /></dd>
<dt class="form_req"><label for="password2">Confirm Password</label></dt>
	<dd class="form_req"><input type="password" name="password2" id="password2" size="30" value="" /></dd>
<dt class="form_req"><label for="username">Username</label></dt>
	<dd class="form_req"><input type="text" name="username" id="username" size="30" value="" /></dd>
<dt class=""><label for="user_type">I am primarily a...</label></dt>
	<dd class=""><select name="user_type" id="user_type" size="1" ><option id="user_type01"  value="0" >select one</option> 
<option id="user_type02"  value="w" >Writer</option> 
<option id="user_type03"  value="p" >Publisher</option> 
<option id="user_type04"  value="b" >Both</option> 
</select>
</dd>
<dt class=""><label for="content_type">I am most insterested in...</label></dt>
	<dd class=""><select name="content_type" id="content_type" size="1" ><option id="content_type01"  value="0" >select one</option> 
<option id="content_type02"  value="f" >Free Content</option> 
<option id="content_type03"  value="p" >Paid Content</option> 
<option id="content_type04"  value="b" >Both</option> 
</select>
</dd>
<dt class=""><label for="heard_about">How did you hear about WriteHive?</label></dt>
	<dd class=""><input type="text" name="heard_about" id="heard_about" size="30" value="" /></dd>
<dt class=""><label for="web_site">Where is your Web site or blog?</label></dt>
	<dd class=""><input type="text" name="web_site" id="web_site" size="30" value="" /></dd>
</dl><div class="form-button-container">
<button class="form-button form-submit" type="submit" name="reg_form_submit">Sign-up</button>
</div>
<input type="hidden" name="event" id="event" value="save"/></form></div></div>


	</div>

</div> <!-- end class container_12 -->
	<!-- end id site_wrapper -->

<div class="container_12">
	<div class="grid_12 alpha omega" id="site_footer">
		<div class="btmnav">
			<ul>
				<li><a href="<?php echo cgn_url();?>">Home</a></li>
				<li><a href="/main.page/about_us.html">About Us</a></li>
				<li><a href="/login.register">Sign-Up</a></li>
				<li><a href="/main.page/syndication_questions.html">FAQ</a></li>
				<li>
					<a href="<?php echo cgn_url();?>main.page/privacy.html">Privacy</a>
				</li>
				<li><a href="http://support.writehive.com/">Contact</a></li>
				<li>
					<a href="<?php echo cgn_url();?>main.page/terms_conditions.html">Terms &amp; Conditions</a>
				</li>
			</ul> 
		</div>
		<div class="rights">&copy;2011 WriteHive. All rights reserved.</div>	
	</div>

</div> <!-- end class container_12 -->

</body>
</head>
