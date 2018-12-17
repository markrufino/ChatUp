//
//  ChatMessageSender.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/10/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct ChatMessageSender: Codable {
	let id: Int
	let name: String
	let email: String?
	let isOnline: Bool?
}

extension ChatMessageSender {

	init(fromUserInfoService userInfoService: UserInfoServicing) {

		self.id = userInfoService.userId

		self.name = userInfoService.username

		self.email = userInfoService.email

		self.isOnline = userInfoService.isOnline

	}

}
