//
//  StringChatMessage.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct StringChatMessage: Codable {
	let message: String
	let sender: DataParam<ChatMessageSender>
}


struct StringChatMessageOutbound: Codable {
	let message: String
	let sender: ChatMessageSender
}
