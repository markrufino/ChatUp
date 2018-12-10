//
//  RootViewController.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, CreatedFromNib {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        perform(#selector(goToChat), with: nil, afterDelay: 2.0)
    }
    
    @objc private func goToChat() {
        self.present(ChatBuilder().build(), animated: true, completion: nil)
    }
    
}
