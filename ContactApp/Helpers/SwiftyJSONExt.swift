//
//  SwiftyJSONExt.swift
//  Twine
//
//  Created by Thanh Nguyen on 2/28/16.
//  Copyright © 2016 Mingle. All rights reserved.
//

import Foundation
import SwiftyJSON

enum JsonType: String {
    case stringType = "String"
    case intType = "Int"
    case floatType = "Float"
    case boolType = "Bool"
    case doubleType = "Double"
}

extension JSON {
    public init(_ object: AnyObject?) {
        if object == nil {
            self.init(NSNull())
        } else {
            self.init(object!)
        }
    }
    

    fileprivate func asType(_ type: JsonType) -> AnyObject? {
        switch type {
        case .stringType:
            return self.stringValue as AnyObject?
        case .intType:
            return self.int as AnyObject?
        case .floatType:
            return self.float as AnyObject?
        case .boolType:
            return self.boolValue as AnyObject?
        case .doubleType:
            return self.double as AnyObject?
        }
    }

    func populateObject(_ object: AnyObject, mapper: [String: [String]]) {
        for key in self.dictionaryValue.keys {
            if let attributes = mapper[key] {
                if let value: AnyObject = self[key].asType(JsonType(rawValue: attributes[1])!) {
                    object.setValue(value, forKey: attributes[0])
                }
            }
        }
    }
}
