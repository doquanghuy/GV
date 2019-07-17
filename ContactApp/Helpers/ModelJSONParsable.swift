//
//  ModelJSONParsable.swift
//  ContactApp
//
//  Created by Ha Ho on 7/17/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ModelJSONParsable {
    static func parseFromJSON(json: JSON, object: Self)
    static func parseCustomFields(json: JSON, object: Self)
    static var mapper: [String: [String]] { get }
}

extension ModelJSONParsable {
    static func parseFromJSON(json: JSON, object: Self) {
        json.populateObject(object as AnyObject, mapper: self.mapper)
        self.parseCustomFields(json: json, object: object)
    }
}
