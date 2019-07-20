//
//  APIManager.swift
//  ContactApp
//
//  Created by Quang Huy on 7/17/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

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
                        completion: ((NSError?, JSON) -> Void)?) -> Request? {
        return Networking.request(url: url, method: method, params: params, encoding: encoding, headers: headers) { (error, json) in
            if let error = error {
                completion?(validateError(networkError: error, response: json), json)
            } else {
                completion?(nil, json)
            }
        }
    }
    
    private static func validateError(networkError: NSError, response: JSON) -> NSError {
        var messageError  = "Something Wrong"
        if let message = response["errors"].arrayValue.first?.string {
            messageError = message
        }
        return NSError(domain: networkError.domain, code: networkError.code, userInfo: [NSLocalizedDescriptionKey: messageError])
    }
}
