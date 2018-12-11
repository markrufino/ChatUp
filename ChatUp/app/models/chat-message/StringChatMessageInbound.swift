//
//  StringChatMessageInbound.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct StringChatMessageInbound: Codable {
	var message: String
	var sender: DataParam<ChatMessageSender>
}
