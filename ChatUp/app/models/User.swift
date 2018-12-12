//
//  User.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

typealias UserResponse = DataResp<User>

struct User: Codable {
	let id: Int
	let name: String
	let email: String
	let isOnline: String
}
