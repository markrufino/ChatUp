//
//  UIDevice+.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {

	static var udid = UIDevice.current.identifierForVendor?.uuidString ?? "<identifier for vendor is null>"
	static var os = "iOS"
	static var osVersion = UIDevice.current.systemVersion
	static var manufacturer = "Apple"
	static var model: String = "<not yet set>"
	static var appVersion = "0.0.1"
	
}
