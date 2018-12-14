//
//  MockRegistrationService.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/14/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

class MockRegistrationService: RegistrationServicing {

	private weak var serviceable: RegistrationServiceable?

	init(serviceable: RegistrationServiceable) {
		self.serviceable = serviceable
	}

	func registerUser(withName name: String, email: String, andPassword password: String) {
		serviceable?.registrationSuccess()
	}

}
