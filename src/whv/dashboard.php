<?php

Cgn::loadModLibrary('Account::Account_Base');
Cgn::loadModLibrary('Account::Account_Address');

class Cgn_Service_Whv_Dashboard extends Cgn_Service {


	public function mainEvent($req, &$t) {
		$user = $req->getUser();
		$account = Account_Base::loadByUserId($user->userId);
		$t['profile'] = $account->_dataItem->valuesAsArray();

		$address = Account_Address::loadByAccountId($account->_dataItem->getPrimaryKey());
		//db errors are "trigger_errors" in case the Cgn_ErrorStack is not used
		// as a handler.
		// an upgrade to the cgn_account_attrib table may result in an
		// error as tables are only dynamically rebuilt on insert/update
		$e = Cgn_ErrorStack::pullError('php');


		$t['profile'] = array_merge($address->valuesAsArray(), $t['profile']);
		$t['profile'] = array_merge($t['profile'], $account->attributes);

		$t['filename']   = 'writehive_1.0.zip';
		$t['filemtime']  = filemtime( BASE_DIR.'/'.$t['filename']);
	}
}
