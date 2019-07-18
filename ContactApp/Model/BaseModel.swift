
//
// BaseModel.swift


import Foundation
import RealmSwift
import SwiftyJSON


protocol BaseModel {
    associatedtype PrimaryKeyType
    static func createOrUpdate(_ json: JSON) -> PrimaryKeyType
    static func createOrUpdate(_ jsons: [JSON])
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

