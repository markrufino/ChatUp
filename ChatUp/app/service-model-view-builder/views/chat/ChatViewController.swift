//
//  ChatViewController.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, CreatedFromNib {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    
    var pushService: PushServicing?

    override func viewDidLoad() {
        super.viewDidLoad()
        pushService?.start(usingCredentials: PusherCredentials.default, withServiceable: self)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSend(_ sender: UIButton) {
        sendStringMessage()
    }
    
    private func sendStringMessage() {
        guard let message = messageTextView.text else { return }
        messageTextView.text = ""
        pushService?.send(message: .text(message))
    }
    
}

extension ChatViewController: PushServiceable {
    
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

