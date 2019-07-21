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
    static func findByID(id: PrimaryKeyType, realmProvider: RealmProvider = RealmProvider(), _ isBackground: Bool = false) -> Self? {
        let realm = realmProvider.realm
        realm.refresh()
        return realm.objects(Self.self).filter("\(Self.primaryKey() ?? "") == %@", id).first
    }
    
    static func findAll(realmProvider: RealmProvider = RealmProvider(), _ isBackground: Bool = false) -> Results<Self> {
        let realm = realmProvider.realm
        realm.refresh()
        return realm.objects(Self.self)
    }
}
