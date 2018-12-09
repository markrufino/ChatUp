//
//  RootBuilder.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

class RootBuilder: BuilderType<RootViewController> {
    
    override func build() -> RootViewController {
        return view
    }

}
