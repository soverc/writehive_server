<?php

class Whv_Reg {

	public function regForm($signal) {
		$req = Cgn_SystemRequest::getCurrentRequest();
		$f        = $signal->_sourceObj->form;
		$values   = $signal->_sourceObj->formValues;
		$f->width = '100%';
//		$signal->_sourceObj->t['result'] = array('echo'=>'echo');

		$uname = new Cgn_Form_ElementInput('username', 'Username');
		$uname->required = TRUE;
		$f->appendElement($uname, $req->cleanString('username'));

		$userType = new Cgn_Form_ElementSelect('user_type', 'I am primarily a...');
		$userType->size = '1';
		$ut = $req->cleanString('user_type');
		$userType->addChoice('select one', '0');
		$userType->addChoice('Writer', 'w');
		$userType->addChoice('Publisher', 'p');
		$userType->addChoice('Both', 'b');
		$f->appendElement($userType, $ut);

		$contentType = new Cgn_Form_ElementSelect('content_type', 'I am most insterested in...');
		$contentType->size = '1';
		$ct = $req->cleanString('content_type');
		$contentType->addChoice('select one', '0');
		$contentType->addChoice('Free Content', 'f');
		$contentType->addChoice('Paid Content', 'p');
		$contentType->addChoice('Both', 'b');
		$f->appendElement($contentType, $ct);

		$heardAbout = new Cgn_Form_ElementInput('heard_about', 'How did you hear about WriteHive?');
		$ha = $req->cleanString('heard_about');
		$f->appendElement($heardAbout, $ha);

		$webSite = new Cgn_Form_ElementInput('web_site', 'Where is your Web site or blog?');
		$ws = $req->cleanString('web_site');
		$f->appendElement($webSite, $ws);


		$signal->_sourceObj->form = $f;
		return TRUE;
	}

	public function regSaveBefore($signal) {
//		var_dump($signal);
		$req = Cgn_SystemRequest::getCurrentRequest();
		if ($req->cleanString('username') == '') {
			return false;
		}


		Cgn_DbWrapper::whenUsing('user', Cgn_Db_Connector::getHandle('mediaplace'));
		$item = new Cgn_DataItem('user');
		$item->andWhere('display_name', $req->cleanString('username'));
		$usernameList = $item->find();
		if (count($usernameList)) {
			Cgn_ErrorStack::throwError('That username is already taken.', 506);
			return false;
		}
		return true;
	}

	public function regSaveAfter($signal) {

		$req = Cgn_SystemRequest::getCurrentRequest();
		$pw  = $signal->_sourceObj->regPw;

		Cgn_DbWrapper::whenUsing('user', Cgn_Db_Connector::getHandle('mediaplace'));
		$item = new Cgn_DataItem('user', NULL);
		$item->set('user_id', cgn_uuid());
		$accountKey  = str_replace('-', '', cgn_uuid());
		$item->set('account_key', 
			sprintf('%s-%s-%s', 
			substr($accountKey, 0, 3),
			substr($accountKey, 3, 3),
			substr($accountKey, 6, 3)
		));
		$item->set('display_name', $req->cleanString('username'));
		$item->set('passwd', $pw);
		$item->set('active', 0);
		$saved =  $item->save();
		if (!$saved) {
			return FALSE;
		}
		//set redirect to whv dashboard
		$signal->_sourceObj->registerAfterUrl = cgn_sappurl('whv', 'dashboard');

		//hash the password
		$db = Cgn_Db_Connector::getHandle('mediaplace');
		return $db->query('UPDATE user SET passwd=PASSWORD(passwd) WHERE user_id = "'.$item->get('user_id').'"');
	}


	public function emailSaveAfter($signal) {

		$email    = $signal->_sourceObj->user->email;
		$username = $signal->_sourceObj->user->username;

		Cgn_DbWrapper::whenUsing('user', Cgn_Db_Connector::getHandle('mediaplace'));
		$item = new Cgn_DataItem('user', NULL);
		$item->_uniqs = array('user_id');
		if ($item->load( array('display_name="'.$username.'"'))) {
			$item->set('email_address', $email);
			$item->save();
		}
		return TRUE;
	}


	public function profileSaveAfter($signal) {

		$attribs   = $signal->_sourceObj->attributes;
		$firstname = $signal->_sourceObj->firstname;
		$lastname  = $signal->_sourceObj->lastname;
		$username  = $signal->_sourceObj->user->username;

		Cgn_DbWrapper::whenUsing('user', Cgn_Db_Connector::getHandle('mediaplace'));
		$item = new Cgn_DataItem('user', NULL);
		$item->_uniqs = array('user_id');
		if ($item->load( array('display_name="'.$username.'"'))) {
			$item->set('first_name', $firstname);
			$item->set('last_name',  $lastname);
			$item->set('website',    $attribs['ws']);
			$item->set('twitter',    $attribs['tw']);
			$item->set('facebook',   $attribs['fb']);
			$item->set('bio',        $attribs['bio']);
			$item->save();
		}
		return TRUE;
	}


	public function passwordSaveAfter($signal) {
		$password  = $signal->_sourceObj->password;
		$username  = $signal->_sourceObj->user->username;

		Cgn_DbWrapper::whenUsing('user', Cgn_Db_Connector::getHandle('mediaplace'));

		$db = Cgn_Db_Connector::getHandle('mediaplace');
		return $db->query('UPDATE user SET passwd=PASSWORD("'.$password.'") WHERE display_name = "'.$username.'"');
	}
}
