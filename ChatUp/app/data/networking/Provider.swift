//
//  Provider.swift
//  StarterKit
//
//  Created by Mark on 24/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Alamofire
import Moya

class Provider: MoyaProvider<API> {
    
    static let `default` = Provider(level: .default)
    static let stubbed = Provider(level: .stubbed)
    
    enum Level {
        case `default`
        case stubbed
    }
    
    init(level: Provider.Level) {
        
        let timeout = 30.0
        let host = URLComponents(url: Config.shared.kBaseURL, resolvingAgainstBaseURL: true)!.host!
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeout
        sessionConfig.timeoutIntervalForResource = timeout
        
        let serverTrust = ServerTrustPolicyManager(policies: [host: .disableEvaluation])
        let manager = Manager(configuration: sessionConfig, serverTrustPolicyManager: serverTrust)
        
        let plugins: [PluginType] = [NetworkLoggerPlugin(verbose: true, cURL: false), AuthTokenExtractorPlugin()]
        
        switch level {
        case .default:
            super.init(manager: manager, plugins: plugins, trackInflights: true)
        case .stubbed:
            super.init(stubClosure: MoyaProvider.immediatelyStub, manager: manager, plugins: plugins, trackInflights: true)
        }
    }
    
}
