//
//  BaseModel.swift
//  ContactApp
//
//  Created by Quang Huy on 7/18/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


protocol BaseModel {
    associatedtype PrimaryKeyType
}

extension BaseModel where Self: Object {
    static func findByID(id: PrimaryKeyType) -> Self? {
        let realm = try! Realm()
        realm.refresh()
        return realm.objects(Self.self).filter("\(Self.primaryKey() ?? "") == %@", id).first
    }
    
    
    static func findAll() -> Results<Self> {
        let realm = try! Realm()
        realm.refresh()
        return realm.objects(Self.self)
    }
}
