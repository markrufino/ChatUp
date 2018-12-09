//
//  ChatService.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import PusherSwift

protocol ChatServicing {
    
    func start(usingCredentials credentials: PusherCredentials, withServiceable serviceable: ChatServiceable)
    
    func send(message: ChatMessageType)
    
}

protocol ChatServiceable {
    
    func allowedChatServiceConnectionRetries() -> Int
    
    func chatServiceSuccessfullyConnected()
    
    func chatServiceConnectionFailed(withRetriesLeft retriesLeft: Int)
    
    func chatService(receivedMessage: ChatMessageType, from sender: String)
    
}

enum ChatMessageType {
    case string(String)
    
    var sendEvent: String {
        return ""
    }
    
    var receiveEvent: String {
        return ""
    }
}

enum ChatEvents {
    case broadCastStringMessage
    
    var stringValue: String {
        switch self {
        case .broadCastStringMessage:
            return "hello123"
        }
    }
}

class ChatService: ChatServicing {

    private var pusher: Pusher?
    private var pusherChannel: PusherChannel?
    private var serviceable: ChatServiceable?
    
    private var retriesLeftForConnecting: Int = 1
    
    func start(usingCredentials credentials: PusherCredentials = PusherCredentials.default, withServiceable serviceable: ChatServiceable) {
        
        self.serviceable = serviceable
        retriesLeftForConnecting = serviceable.allowedChatServiceConnectionRetries()
        
        self.pusher = {
            let options = PusherClientOptions(host: .cluster(credentials.cluster))
            let pusher = Pusher(withAppKey: credentials.key, options: options)
            retriesLeftForConnecting = serviceable.allowedChatServiceConnectionRetries()
            pusher.connect()
            pusher.delegate = self
            return pusher
        }()
        
        self.pusherChannel = pusher?.subscribe(credentials.channel)
        self.pusherChannel?.bind(eventName: ChatEvents.broadCastStringMessage.stringValue, callback: handleDataFromBroadCastStringEvent(_:))
    }
    
    // TODO: - Ask for json format of data so that decodable can be used instead of casting.
    private func handleDataFromBroadCastStringEvent(_ data: Any?) {
        guard let dict = data as? [String: AnyObject] else { return }
        guard let message = dict ["message"] as? String else { return }
        guard let sender = dict["sender"] as? String else { return }
        serviceable?.chatService(receivedMessage: ChatMessageType.string(message), from: sender)
    }
    
    func send(message: ChatMessageType) {
        switch message {
        case .string(let stringMessage):
            pusherChannel?.trigger(eventName: ChatEvents.broadCastStringMessage.stringValue, data: stringMessage)
        }
    }
    
}

extension ChatService: PusherDelegate {
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        switch (old, new) {
        case (.connecting, .connected):
            serviceable?.chatServiceSuccessfullyConnected()
        case (.connecting, .disconnected):
            retriesLeftForConnecting -= 1
            serviceable?.chatServiceConnectionFailed(withRetriesLeft: retriesLeftForConnecting)
            if retriesLeftForConnecting == 0 { pusher?.disconnect() }
        default:
            break
        }
    }
    
}


