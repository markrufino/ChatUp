//
//  LogoutService.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/13/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

protocol LogoutServicing {

	func logout()

}

protocol LogoutServiceable: AnyObject {

	func userWasSuccessfullyLoggedOut()

}

class LogoutService: LogoutServicing {

	init(toService serviceable: LogoutServiceable) {
		self.serviceable = serviceable
	}

	func logout() {
		let keychain = Keychain()
		keychain.apiAccessToken = nil
		self.serviceable?.userWasSuccessfullyLoggedOut()
	}

	// MARK: - Private
	private weak var serviceable: LogoutServiceable?
}
