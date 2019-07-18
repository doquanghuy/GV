//

//

import Foundation

class ContactViewModel {
    
    private var contact: Contact?
    
    var shouldReloadData = Dynamic<Bool>(false)
    var errorMessage = Dynamic<String?>(nil)

    var fullName = Dynamic<String>("")
    var email = Dynamic<String?>(nil)
    var phoneNumber = Dynamic<String?>(nil)
    var urlProfilPic = Dynamic<String?>(nil)
    var favorite = Dynamic<Bool>(false)
    
    init(contact: Contact) {
        self.contact = contact
        obsever()
        handleObsever()
    }
    
    private func obsever() {
        guard let contact = contact else { return }
        RealmNotification.share.observerObjectChanged(object: contact)
    }
    
    private func handleObsever() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactChange(_:)), name: NSNotification.Name(rawValue: RealmNotificationType.change.rawValue), object: nil)
    }
    
    @objc private func handleContactChange(_ notification: Notification) {
        reloadData()
    }
    
    public func getDetailContact() {
        guard let contactId = contact?.id else { return }
        APIManager.Contact.getContactDetail(contactId) { (error, json) in
            if let error = error {
                self.errorMessage.value = error.localizedDescription
            } else {
                Contact.createOrUpdate(json)
            }
        }
    }
    
    func reloadData() {
        guard let contact = contact else { return }
        fullName.value = "\(contact.first_name) \(contact.last_name)"
        email.value = contact.email
        phoneNumber.value = contact.phone_number
        urlProfilPic.value = contact.profile_pic
        favorite.value = contact.favorite
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
}
