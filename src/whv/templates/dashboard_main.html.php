
<h2>WriteHive Dashboard</h2>

<div style="border:1px solid black;padding:7px;">
<div class="acct-sect-hdr" style="font-size:140%;">WordPress Plugin</div>
	<span style="float:left;width:8.5em;">Link:</span>
	<span style="font-weight:bold;"><a href="<?php echo cgn_url().$t['filename'];?>"><?php echo $t['filename'];?></a></span>
<br style="clear:both;"/>
	<span style="float:left;width:8.5em;clear:left;">Release date:</span> 
	<span style=""><?php echo date('l, F jS Y G:i:s', $t['filemtime']);?></span>
<br style="clear:both;"/>
</div>

<br style="clear:both;"/>




<h2>Public Profile</h2>
<div style="border:1px solid black;padding:7px;">
	<span style="float:left;width:8.5em;">Display Name:</span>
	<span style="font-weight:bold;"><?php echo htmlspecialchars($u->getDisplayName());?></span>
	<br style="clear:both;"/>

	<span style="float:left;width:8.5em;">Public profile link:</span>
	<span style="font-weight:bold;"><a href="<?php echo cgn_sappurl('profile'). $t['profile']['cgn_account_id'].'_'. str_replace(' ', '_', htmlspecialchars($u->getDisplayName()));?>.html"><?php echo cgn_sappurl('profile'). $t['profile']['cgn_account_id'].'_'. str_replace(' ', '_', htmlspecialchars($u->getDisplayName()));?>.html</a></span>
	<br style="clear:both;"/>


	<span style="float:left;width:8.5em;">Web Site:</span>
	<span style="font-weight:bold;"><a href="<?php echo htmlspecialchars($t['profile']['ws']);?>"><?php echo htmlspecialchars($t['profile']['ws']);?></a></span>
	<br style="clear:both;"/>

	<span style="float:left;width:8.5em;">Twitter:</span>
	<span style="font-weight:bold;"><a href="<?php echo htmlspecialchars($t['profile']['tw']);?>"><?php echo htmlspecialchars($t['profile']['tw']);?></a></span>
	<br style="clear:both;"/>

	<span style="float:left;width:8.5em;">Facebook:</span>
	<span style="font-weight:bold;"><a href="<?php echo htmlspecialchars($t['profile']['fb']);?>"><?php echo htmlspecialchars($t['profile']['fb']);?></a></span>
	<br style="clear:both;"/>

	<span style="float:left;width:8.5em;">About you:</span>
	<span style=""><?php echo htmlspecialchars($t['profile']['bio']);?></span>
	<br style="clear:both;"/>




	<img style="float:right;vertical-align:middle;margin-right:60%;" src="<?=cgn_sappurl('account', 'img', '', array('r'=>rand()));?>"/>
	<span class="acct-sect-hdr" style="font-size:140%;">Profile Picture</span>
	<br style="clear:both;"/>


	<a href="<?=cgn_appurl('account');?>">Change your account settings</a>
</div>

