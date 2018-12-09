//
//  CreatedFromNib.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import UIKit

protocol CreatedFromNib: AnyObject {
    static func create(fromBundle bundle: Bundle?) -> Self
}

extension CreatedFromNib where Self: UIViewController {
    
    static func create(fromBundle bundle: Bundle? = nil) -> Self {
        return Self(nibName: String(describing: Self.self), bundle: bundle)
    }
    
}
