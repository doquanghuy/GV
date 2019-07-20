//

//

import Foundation
import SwiftyJSON
import RealmSwift

@objcMembers
final class Contact: Object {
    dynamic var id = 0
    dynamic var first_name: String = Constant.String.empty
    dynamic var last_name: String = Constant.String.empty
    dynamic var profile_pic: String = Constant.String.empty
    dynamic var favorite: Bool = false
    dynamic var email: String? = nil
    dynamic var phone_number: String? = nil
    dynamic var group: Group?
    
    var full_name: String {
        return "\(self.first_name) \(self.last_name)"
    }
    
    override class func primaryKey() -> String {
        return Constant.ContactKeys.id
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
                let id = json[Constant.ContactKeys.id].intValue
                contact = Contact.findByID(id: id) ?? Contact()
                parseFromJSON(json: json, object: contact)
                
                let name = contact.first_name
                var firstCharacter: String = (name.first != nil) ? String(name.first!) : Constant.String.defaultContactName
                firstCharacter = firstCharacter.isAlphabet ? firstCharacter.uppercased() : Constant.String.defaultContactName
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
                    let id = json[Constant.ContactKeys.id].intValue
                    let contact = Contact.findByID(id: id) ?? Contact()
                    parseFromJSON(json: json, object: contact)
                    
                    let name = contact.first_name
                    var firstCharacter: String = (name.first != nil) ? String(name.first!) : Constant.String.defaultContactName
                    firstCharacter = firstCharacter.isAlphabet ? firstCharacter.uppercased() : Constant.String.defaultContactName
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
            Constant.ContactKeys.firstName: [Constant.ContactKeys.firstName, "String"],
            Constant.ContactKeys.lastName: [Constant.ContactKeys.lastName, "String"],
            Constant.ContactKeys.profilePic: [Constant.ContactKeys.profilePic, "String"],
            Constant.ContactKeys.favorite: [Constant.ContactKeys.favorite, "Bool"],
            Constant.ContactKeys.email: [Constant.ContactKeys.email, "String"],
            Constant.ContactKeys.phoneNumber: [Constant.ContactKeys.phoneNumber, "String"]
        ]
    }
    
    static func parseCustomFields(json: JSON, object: Contact) {
        if object.realm == nil { object.id = json[Constant.ContactKeys.id].intValue }
    }
}
