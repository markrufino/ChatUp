//
//  Provider+refreshTokenThenRetry.swift
//  ChatUp
//
//  Created by Mark on 13/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import Moya

extension Provider {
    
    func refreshTokenThenRetry(_ target: API, completion: () -> Void) {
        self.request(.refreshToken) { (result) in
            <#code#>
        }
    }
    
}
