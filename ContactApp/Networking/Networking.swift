//
//  Networking.swift
//  Niche
//
//  Created by Tung Tran on 11/28/18.
//  Copyright © 2018 Mingle2. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Networking {
    private init() {}
}

// MARK: - Method
extension Networking {
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case trace = "TRACE"
        case connect = "CONNECT"
        
        var alamofireMethod: Alamofire.HTTPMethod {
            switch self {
            case .post:
                return .post
            default:
                return Alamofire.HTTPMethod(rawValue: rawValue) ?? .post
            }
        }
    }
}

// MARK: - Parameter Encoding
extension Networking {
    enum ParamEncoding {
        case jsonDefault
        case urlDefault
        case urlQueryString
        
        var alamofireEncoding: ParameterEncoding {
            switch self {
            case .jsonDefault:
                return JSONEncoding.default
            case .urlDefault:
                return URLEncoding.default
            case .urlQueryString:
                return URLEncoding.queryString
            }
        }
    }
}

// MARK: - Request
extension Networking {
    static func request(url: String, method: Networking.HTTPMethod, params: [String: Any], encoding: ParamEncoding? = nil,
                        headers: [String: String]? = nil, completion: ((NSError?, JSON) -> Void)?) {
        var paramEncoding = encoding
        if paramEncoding == nil {
            switch method {
            case .post, .put:
                paramEncoding = .jsonDefault
            default:
                paramEncoding = .urlDefault
            }
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        Alamofire.request(url, method: method.alamofireMethod, parameters: params, encoding: paramEncoding!.alamofireEncoding, headers: headers)
            .validate()
            .responseString { (response) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                switch response.result {
                case .failure(let error as NSError):
                    guard let data = response.data, let stringValue = String(data: data, encoding: .utf8) else {
                        completion?(error, JSON(parseJSON: response.description))
                        return
                    }
                    completion?(error, JSON(parseJSON: stringValue))
                case .success(let value):
                    completion?(nil, JSON(parseJSON: value))
                }
            }
    }
}

// MARK: - Download file
extension Networking {
    static func downloadFile(stringURL: String, completion: @escaping (NSError?, URL?) -> Void) {
        Alamofire.download(stringURL).response { (response) in
            if let error = response.error {
                let nsError = error as NSError
                completion(nsError, nil)
                return
            }
            completion(nil, response.destinationURL)
        }
    }
}

