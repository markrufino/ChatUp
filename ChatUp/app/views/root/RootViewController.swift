//
//  RootViewController.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, CreatedFromNib {

	deinit {
		let typeName = String(describing: self)
		print("\(typeName) instance was deallocated.")
	}

	weak var coordinator: RootCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
		DispatchQueue.main.async {
			self.goToLogin()
		}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc private func goToLogin() {
		self.coordinator?.rootGoToLogin()
    }

}
