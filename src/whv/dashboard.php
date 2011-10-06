<?php

Cgn::loadModLibrary('Account::Account_Base');
Cgn::loadModLibrary('Account::Account_Address');

class Cgn_Service_Whv_Dashboard extends Cgn_Service {


	public function mainEvent($req, &$t) {
		$user = $req->getUser();
		$account = Account_Base::loadByUserId($user->userId);
		$t['profile'] = $account->_dataItem->valuesAsArray();

		$address = Account_Address::loadByAccountId($account->_dataItem->getPrimaryKey());
		$t['profile'] = array_merge($address->valuesAsArray(), $t['profile']);
		$t['profile'] = array_merge($t['profile'], $account->attributes);
	}
}
