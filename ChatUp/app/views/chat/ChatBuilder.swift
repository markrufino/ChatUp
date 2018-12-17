//
//  ChatBuilder.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct ChatDependency: DependencyType {
	var coordinator: ChatCoordinator
}

class ChatBuilder: BuilderType<ChatViewController, ChatDependency> {

	override func build(_ dependency: ChatDependency) -> ChatViewController {
		let userInfoService = UserInfoService()
		let credentials = PusherKeys.default
		view.coordinator = dependency.coordinator
		view.userInfoService = userInfoService

		#if DEBUG
//			view.chatService = MockChatService(serviceable: view)
		#else
//			view.chatService = ChatService(Provider.default, withUserInfoService: userInfoService, andCredentials: credentials, servicing: view, inChannel: 1)
		#endif


		view.logoutService = LogoutService(toService: view)
        return view
    }
    
}
