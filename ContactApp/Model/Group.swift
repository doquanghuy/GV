//
//  Group.swift
//  ContactApp
//
//  Created by Quang Huy on 7/20/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    @objc dynamic var id: String = Constant.String.empty
    @objc dynamic var sortKey: String = Constant.String.empty
    let contacts = LinkingObjects(fromType: Contact.self, property: "group")    

    override static func primaryKey() -> String {
        return Constant.GroupKeys.id
    }
}

// MARK: -BaseModel
extension Group: BaseModel {
    typealias PrimaryKeyType = String    
}

