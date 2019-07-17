//

//

import Foundation

class ContactViewModel {
    
//    private let networking = Networking()
    
    private var contact: Contact?
    
    public func setData(contact: Contact){
        self.contact = contact
    }
    
    public func getDetailContact(contactId: Int, completion: (() -> Void)?, errorCompletion: ((_ messages: String?) -> Void)?){
//        networking.performNetworkTask(endpoint: APIServices.getContact(contactId: contactId), type: Contact.self, completion: { (response) in
//            self.contact = response
//            completion?()
//        }) { (errorMessages) in
//            errorCompletion?(errorMessages)
//        }
    }
    
    public func updateContact(first_name: String, last_name: String, email: String?, phone_number: String?, favorite: Bool, completion: (() -> Void)?, errorCompletion: ((_ messages: String?) -> Void)?){
//        networking.performNetworkTask(endpoint: APIServices.updateContact(
//            id: (contact?.id)!,
//            first_name: first_name,
//            last_name: last_name,
//            email: email,
//            phone_number: phone_number,
//            favorite: favorite), type: Contact.self, completion: { (response) in
//            self.contact = response
//            completion?()
//        }) { (errorMessages) in
//            errorCompletion?(errorMessages)
//        }
    }
    
    public func addContact(first_name: String, last_name: String, email: String?, phone_number: String?, completion: (() -> Void)?, errorCompletion: ((_ messages: String?) -> Void)?){
//        networking.performNetworkTask(endpoint: APIServices.addContact(
//            first_name: first_name,
//            last_name: last_name,
//            email: email,
//            phone_number: phone_number), type: Contact.self, completion: { (response) in
//                self.contact = response
//                completion?()
//        }) { (errorMessages) in
//            errorCompletion?(errorMessages)
//        }
    }
    
    var id: Int {
        return (contact?.id)!
    }
    
    var fullName: String {
        return "\(contact!.first_name) \(contact!.last_name)"
    }
    
    var firstName: String {
        return contact!.first_name
    }
    
    var lastName: String {
        return contact!.last_name
    }
    
    var email: String {
        return contact!.email!
    }
    
    var phoneNumber: String {
        return contact!.phone_number!
    }
    
    var urlProfilPic: URL {
        return URL(string: contact!.profile_pic)!
    }
    
    var favorite: Bool {
        return contact!.favorite
    }
}
