//
//  PushService.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import PusherSwift

protocol PushServicing {
    func start(usingCredentials credentials: PusherCredentials, withServiceable serviceable: PushServiceable)
    func send(message: PushServiceMessageType)
}

protocol PushServiceable {
    func pushServiceHasConnectedSuccessfully()
    func pushServiceDidNotConnectSuccessfully()
    func pushServiceable(receivedMessage: PushServiceMessageType)
}

enum PushServiceMessageType {
    case text(String)
}

enum PushServiceEvent: String {
    case stringMessageReceived
    case stringMessageSend
}

class PushService: PushServicing {
    
    var pusher: Pusher?
    var channel: PusherChannel?
    
    private var serviceable: PushServiceable?
    
    func start(usingCredentials credentials: PusherCredentials, withServiceable serviceable: PushServiceable) {
        let options = PusherClientOptions(host: .cluster(credentials.cluster))
        pusher = Pusher(withAppKey: credentials.key, options: options)
        channel = pusher?.subscribe(channelName: credentials.channel)
        self.serviceable = serviceable
        channel?.bind(eventName: PushServiceEvent.stringMessageReceived.rawValue, callback: handleReceivedStringMessage(_:))
    }
    
    private func handleReceivedStringMessage(_ data: Any?) {
        guard let jsonData = data as? [String: AnyObject] else { return }
        
        if let text = jsonData["message"] as? String {
            serviceable?.pushServiceable(receivedMessage: .text(text))
        }
        
    }

    func send(message: PushServiceMessageType) {
        switch message {
        case .text(let stringMessage):
            channel?.trigger(eventName: PushServiceEvent.stringMessageSend.rawValue, data: stringMessage)
        }
        
    }
    
}




