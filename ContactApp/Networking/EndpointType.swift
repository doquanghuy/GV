//
//  EndpointType.swift
//

import Foundation

protocol EndpointType {
    
    var baseURL: URL { get }
    
    var path: String { get }
    
    var method: String { get }
    
    var parameters: [String:Any] { get }
}
