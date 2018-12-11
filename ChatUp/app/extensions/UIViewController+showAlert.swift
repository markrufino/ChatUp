//
//  UIViewController+showAlert.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

	enum AlertType {
		case success
		case info(customTitle: String)
		case error
	}

	func showAlert(withType alertType: AlertType,
				   andMessage message: String,
				   okActionHandler: (() -> Void)? = nil,
				   cancelActionHandler: (() -> Void)? = nil) {

		let title: String

		switch alertType {
		case .success: title = "Success"
		case .error: title = "Error"
		case .info(let customTitle): title = customTitle
		}

		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		if okActionHandler != nil {
			let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in okActionHandler?() })
			alert.addAction(okAction)
		}

		if cancelActionHandler != nil {
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in cancelActionHandler?() })
			alert.addAction(cancelAction)
		}

		if okActionHandler == nil && cancelActionHandler == nil {
			let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alert.addAction(defaultAction)
		}

		present(alert, animated: true, completion: nil)

	}

}
