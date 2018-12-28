//
//  Provider+request2.swift
//  ChatUp
//
//  Created by Mark on 28/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//


import Foundation
import Moya
import RxSwift

extension Provider {
    
    func request2(_ service: API) -> Observable<Response> {
        return self
            .rx
            .request(service)
            .filterSuccessfulStatusCodes()
            .catchError({ (e) in
                
                guard let error = e as? MoyaError else { throw e }
                guard case .statusCode(let errorResp) = error else { throw e }
                
                
                if errorResp.statusCode == 401 {
                    
                    switch service {
                    case .login, .refreshToken: // or .refreshToken for that matter, just throw E.
                        throw e
                    default:
                        print("--- Access token has expired, refreshing...")
                        let message = "Access token was refreshed!"
                        return self.request2(.refreshToken)
                            .do(onNext: { _ in print(message) })
                            .flatMap { _ in self.request2(service) }
                            .asSingle()
                    }
                    
                }
                
                throw error
            })
            .asObservable()
    }
    
    
}
