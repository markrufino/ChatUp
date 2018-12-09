//
//  RootViewController.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, CreatedFromNib {
    var pushService: PushServicing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pusherCredentials = PusherCredentials.create(fromJSONFileWithName: "pusher_credentials")
        pushService?.start(usingCredentials: pusherCredentials, withServiceable: self)
    }
}

extension RootViewController: PushServiceable {
    
    func pushServiceHasConnectedSuccessfully() {
        print("Push service connection success!")
    }
    
    func pushServiceDidNotConnectSuccessfully() {
        print("Push service connection failed!")
    }
    
    func pushServiceable(receivedMessage: PushServiceMessageType) {
        print(receivedMessage)
    }
    
}
