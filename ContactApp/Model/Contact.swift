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
    
    static func createGroup(from contact: Contact, realmProvider: RealmProvider = RealmProvider()) -> Group {
        let realm = realmProvider.realm
        let name = contact.first_name
        var firstCharacter: String = (name.first != nil) ? String(name.first!) : Constant.String.defaultContactName
        firstCharacter = firstCharacter.isAlphabet ? firstCharacter.uppercased() : Constant.String.defaultContactName
        var group = realm.object(ofType: Group.self, forPrimaryKey: firstCharacter)
        if group == nil {
            group = Group()
            group?.id = firstCharacter
            group?.sortKey = firstCharacter.isAlphabet ? firstCharacter : Constant.String.sortKeyDefault
        }
        return group!
    }
    
    static func createOrUpdate(realmProvider: RealmProvider = RealmProvider(), _ isBackground: Bool = true, _ json: JSON, _ completion: ((_ contact: Contact?) -> Void)? = nil) {
        let queue = isBackground ? Constant.ConcurrentQueue.queue : DispatchQueue.main
        queue.async {
            let realm = realmProvider.realm
            var contact: Contact!
            
            try! realm.write {
                let id = json[Constant.ContactKeys.id].intValue
                contact = Contact.findByID(id: id, realmProvider: realmProvider, isBackground) ?? Contact()
                parseFromJSON(json: json, object: contact)
                contact.group = createGroup(from: contact, realmProvider: realmProvider)
                realm.add(contact, update: true)
            }
            completion?(contact)
        }
    }
    
    static func createOrUpdate(realmProvider: RealmProvider = RealmProvider(), _ isBackground: Bool = true, _ jsons: [JSON], _ completion: ((_ contacts: [Contact]) -> Void)? = nil) {
        let queue = isBackground ? Constant.ConcurrentQueue.queue : DispatchQueue.main
        queue.async {
            let realm = realmProvider.realm
            var contacts = [Contact]()
            
            try! realm.write {
                for json in jsons {
                    let id = json[Constant.ContactKeys.id].intValue
                    let contact = Contact.findByID(id: id, realmProvider: realmProvider, isBackground) ?? Contact()
                    parseFromJSON(json: json, object: contact)
                    contact.group = createGroup(from: contact, realmProvider: realmProvider)
                    contacts.append(contact)
                }
                realm.add(contacts, update: true)
            }
            completion?(contacts)
        }
    }
    
    static func createOrUpdate(realmProvider: RealmProvider = RealmProvider(), _ isBackground: Bool = false, _ contacts: [Contact], _ completion: ((_ contacts: [Contact]) -> Void)? = nil) {
        let realm = realmProvider.realm
        
        try! realm.write {
            for contact in contacts {
                contact.group = createGroup(from: contact, realmProvider: realmProvider)
            }
            realm.add(contacts, update: true)
        }
        completion?(contacts)
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

extension Contact {
    func toJSON() -> Dictionary<String, AnyObject> {
        return [
            Constant.ContactKeys.id: self.id as AnyObject,
            Constant.ContactKeys.firstName: self.first_name as AnyObject,
            Constant.ContactKeys.lastName: self.last_name as AnyObject,
            Constant.ContactKeys.email: self.email as AnyObject,
            Constant.ContactKeys.phoneNumber: self.phone_number as AnyObject,
            Constant.ContactKeys.profilePic: self.profile_pic as AnyObject,
            Constant.ContactKeys.favorite: self.favorite as AnyObject
        ]
    }
}
