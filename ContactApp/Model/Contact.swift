//

//

import Foundation
import RealmSwift
import SwiftyJSON
import RealmSwift

@objcMembers
final class Contact: Object {
    dynamic var id = 0
    dynamic var first_name: String = ""
    dynamic var last_name: String = ""
    dynamic var profile_pic: String = ""
    dynamic var favorite: Bool = false
    dynamic var email: String? = nil
    dynamic var phone_number: String? = nil
    
    override class func primaryKey() -> String {
        return "id"
    }
}

// MARK: -BaseModel
extension Contact: BaseModel {
    @discardableResult
    static func createOrUpdate(_ json: JSON) -> Int {
        let id = json["id"].intValue
        let realm = try! Realm()
        try! realm.write {
            let contact = Contact.findByID(id: id) ?? Contact()
            parseFromJSON(json: json, object: contact)
            realm.add(contact, update: true)
        }
        return id
    }
}

// MARK: - MGModelJSONParsable
extension Contact: ModelJSONParsable {
    static var mapper: [String: [String]] {
        return [
            "first_name": ["first_name", "String"],
            "last_name": ["last_name", "String"],
            "profile_pic": ["profile_pic", "String"],
            "favorite": ["favorite", "Bool"],
            "email": ["email", "String"],
            "phone_number": ["phone_number", "String"]
        ]
    }
    
    static func parseCustomFields(json: JSON, object: Contact) {
         if object.realm == nil { object.id = json["id"].intValue }
    }
}

