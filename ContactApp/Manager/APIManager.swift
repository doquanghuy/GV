//
//  APIManager.swift
//  Niche
//
//  Created by Tung Tran on 11/28/18.
//  Copyright © 2018 Mingle2. All rights reserved.
//

import Foundation
import SwiftyJSON

struct APIManager {
    private init() {}
    
    static var headers: [String: String] {
      return [
            "Content-Type": "application/json"
        ]
    }
    
    static func apiEndPoint(endPoint: String, _ arguments: CVarArg...) -> String {
        return Constant.BASE_URL + String(format: endPoint, arguments: arguments)
    }
    
    static func request(url: String, method: Networking.HTTPMethod, params: [String: Any], encoding: Networking.ParamEncoding? = nil,
                        completion: ((NSError?, JSON) -> Void)?) {
        Networking.request(url: url, method: method, params: params, encoding: encoding, headers: headers) { (error, json) in
            if let error = error {
                completion?(validateError(networkError: error, response: json), json)
            } else {
               completion?(nil, json)
            }
        }
    }
    
    private static func validateError(networkError: NSError, response: JSON) -> NSError {
        var messageError  = "Something Wrong"
        if let message = response["errors"].string {
            messageError = message
        }
        return NSError(domain: networkError.domain, code: networkError.code, userInfo: [NSLocalizedDescriptionKey: messageError])
    }
}
