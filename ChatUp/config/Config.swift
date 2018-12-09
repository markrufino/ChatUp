//
//  Config.swift
//  StarterKit
//
//  Created by Mark on 18/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct Config: Decodable {
    
    let kBaseURL: URL
    let kNamespace: String
    
    static let shared = Config(Bundle.main.infoDictionary!)
    
    init(_ dictionary: [String: Any]) {
        guard JSONSerialization.isValidJSONObject(dictionary) else {
            fatalError()
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        self = try! JSONDecoder().decode(Config.self, from: jsonData)
    }
    
}
