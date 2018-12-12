//
//  ChatBuilder.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

class ChatBuilder: BuilderType<ChatViewController> {

    override func build() -> ChatViewController {
		let userInfoService = UserInfoService()
		let credentials = PusherKeys.default
		view.userInfoService = userInfoService
		view.chatService = ChatService(Provider.default, withUserInfoService: userInfoService, andCredentials: credentials, servicing: view)
        return view
    }
    
}
