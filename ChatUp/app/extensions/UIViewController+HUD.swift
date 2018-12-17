//
//  UIViewController+HUD.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/17/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import MBProgressHUD
import UIKit

extension UIViewController {

	func showHUD() {
		MBProgressHUD.showAdded(to: view, animated: true)
	}

	func hideHUD() {
		MBProgressHUD.hide(for: view, animated: true)
	}

}
