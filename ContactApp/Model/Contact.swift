//

//

import Foundation
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
    dynamic var group: Group?
    
    override class func primaryKey() -> String {
        return "id"
    }
}

// MARK: -BaseModel
extension Contact: BaseModel {
    typealias PrimaryKeyType = Int
    
    static func createOrUpdate(_ json: JSON, completion: ((_ contact: Contact?) -> Void)? = nil) {
        Constant.ConcurrentQueue.queue.async {
            let realm = try! Realm()
            var contact: Contact!
            
            try! realm.write {
                let id = json["id"].intValue
                contact = Contact.findByID(id: id) ?? Contact()
                parseFromJSON(json: json, object: contact)
                
                let name = contact.first_name
                var firstCharacter: String = (name.first != nil) ? String(name.first!) : "N/A"
                firstCharacter = firstCharacter.isAlphabet ? firstCharacter.uppercased() : "N/A"
                var group = realm.object(ofType: Group.self, forPrimaryKey: firstCharacter)
                if group == nil {
                    group = Group()
                    group?.id = firstCharacter
                }
                contact.group = group
                realm.add(contact, update: true)
            }
            completion?(contact)
        }
    }
    
    static func createOrUpdate(_ jsons: [JSON], completion: ((_ contacts: [Contact]) -> Void)? = nil) {
        Constant.ConcurrentQueue.queue.async {
            let realm = try! Realm()
            var contacts = [Contact]()
            
            try! realm.write {
                for json in jsons {
                    let id = json["id"].intValue
                    let contact = Contact.findByID(id: id) ?? Contact()
                    parseFromJSON(json: json, object: contact)
                    
                    let name = contact.first_name
                    var firstCharacter: String = (name.first != nil) ? String(name.first!) : "N/A"
                    firstCharacter = firstCharacter.isAlphabet ? firstCharacter.uppercased() : "N/A"
                    var group = realm.object(ofType: Group.self, forPrimaryKey: firstCharacter)
                    if group == nil {
                        group = Group()
                        group?.id = firstCharacter
                    }
                    contact.group = group
                    contacts.append(contact)
                }
                realm.add(contacts, update: true)
            }
            completion?(contacts)
        }
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
