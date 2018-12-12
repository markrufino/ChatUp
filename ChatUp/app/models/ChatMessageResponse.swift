//
//  ChatMessageResponse.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

typealias ChatMessageResponse = DataResp<ChatMessageResponseMeta>

struct ChatMessageResponseMeta: Codable {
	let id: Int?
	let message: String
	let sender: DataResp<ChatMessageSender>
}
