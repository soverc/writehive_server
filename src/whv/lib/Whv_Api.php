<?php

class Whv_Api {

	public function echoSignal($signal) {
		$signal->_sourceObj->t['result'] = array('echo'=>'echo');
	}

	public function login($signal) {
		$req = Cgn_SystemRequest::getCurrentRequest();
		$u = $req->getUser();

		if (!Cgn::loadLibrary('lib_cgn_authc')) {
			$signal->_sourceObj->t['result'] = array('failed'=>'true');
			$signal->_sourceObj->t['errors'][] = 'Interal server error';
			return TRUE;
		}
		$authenticator = new Cgn_Authentication_Mgr();

		$uname = $req->cleanString('username');
		$pass  = $req->cleanString('password');
		if (!$pass) {
			$pass  = $req->cleanString('passwd');
		}
		$goodLogin = $authenticator->login($uname, $pass);
		$subj = $authenticator->getSubject();

		if ($goodLogin) {
			$attribs = $subj->attributes;
			//clean up sensitive info
			$userAttribs = array();

//			var_dump($attribs);exit();
			if ($attribs['enable_agent'] == 1) 
			$userAttribs['agent_key'] = $attribs['agent_key'];

			$userAttribs['locale']    = $attribs['locale'];
			$userAttribs['tzone']     = $attribs['tzone'];
			$userAttribs['active_on'] = $attribs['active_on'];
			$signal->_sourceObj->t['result'] = array('attributes'=>$userAttribs);
			return TRUE;
		}

		$signal->_sourceObj->t['result'] = array('failed'=>'true');
		$signal->_sourceObj->t['errors'][] = 'login failed';
		/*
		 */
		return TRUE;
	}

}
