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
			<a href="<?php echo cgn_url();?>">home</a>
		</div>
		<div class="grid_1">
			<a href="<?php echo cgn_url();?>blog">blog</a>
		</div>
		<div class="grid_1">
			<a href="<?php echo cgn_url();?>main.page/about_us.html">about</a>
		</div>

		<div class="grid_5 prefix_3 omega">
	<?php if ($u->isAnonymous() ): ?>

		<form action="<?php echo cgn_appurl('login', 'main', 'login');?>" method="post">

		<input type="text"     size="12"  name="username">
			&nbsp;
		<input type="password" size="12"  name="password">
			&nbsp;

		<input class="color_1" type="button"   value="Sign-In" size="12">
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
			<img src="<?php echo cgn_templateurl();?>images/writehive_logo_sm.png"/>
		</div>
	</div>

	<div class="grid_10 prefix_1 suffix_1 alpha omega">
		<?php Cgn_Template::showSessionMessages();  ?>
		<?php echo Cgn_Template::parseTemplateSection('content.main'); ?>
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
		<div class="rights">&copy;2011 WriteCrowd. All rights reserved.</div>	
	</div>

</div> <!-- end class container_12 -->

</body>
</head>
