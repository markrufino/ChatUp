//
//  StringChatMessageInbound.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

typealias StringChatMessageInbound = DataParam<StringChatMessageInboundMeta>

struct StringChatMessageInboundMeta: Codable {
	var message: String
	var sender: DataParam<ChatMessageSender>
}
