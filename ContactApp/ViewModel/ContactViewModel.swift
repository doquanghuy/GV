//

//

import Foundation

class ContactViewModel {
    
    private var contact: Contact?
    
    var shouldReloadData = Dynamic<Bool>(false)
    var errorMessage = Dynamic<String?>(nil)
    var updateErrorMessage = Dynamic<String?>(nil)
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
        APIManager.APIContact.getContactDetail(contactId) { (error, json) in
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
    
    public func updateContact(favorite: Bool) {
        guard let contact = contact else { return }
        let params: [String: Any] = ["favorite": favorite]
        APIManager.APIContact.updateContact(contact.id, params: params){ (error, json) in
            if let error = error {
                self.updateErrorMessage.value = error.localizedDescription
            } else {
                Contact.createOrUpdate(json)
            }
        }
    }
}
