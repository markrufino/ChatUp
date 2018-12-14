//
//  MainCoordinator.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/14/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator<VC: UIViewController & CreatedFromNib> {

	private var rootViewController: UINavigationController

	init() {
		self.rootViewController = UINavigationController(rootViewController: VC.create())
	}

	func goToLogin() {
		rootViewController.present(LoginBuilder().build(), animated: true, completion: nil)
	}

	func goToChat() {
		rootViewController.present(ChatBuilder().build(), animated: true, completion: nil)
	}

	func logOutToRoot() {
		rootViewController.popToRootViewController(animated: true)
	}

}
