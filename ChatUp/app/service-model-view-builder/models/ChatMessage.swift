//
//  ChatMessage.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct DataParam<E: Encodable>: Encodable {
    let data: E
}

struct ChatMessage: Encodable {
    let message: String
    let sender: DataParam<ChatMessageSender>
}

struct ChatMessageSender: Encodable {
    let id: Int
    let name: String
}
