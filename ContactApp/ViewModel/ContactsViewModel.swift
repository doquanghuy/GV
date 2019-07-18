//

//

import Foundation

class ContactsViewModel {
    var shouldReloadData = Dynamic<Bool>(false)
    var errorMessage = Dynamic<String?>(nil)
    private var contacts = [Contact]()
    
    init() {
        obsever()
        handleObsever()
    }
    
    public func getContactList(){
        APIManager.Contact.getContacts { (error, json) in
            if let error = error {
                self.errorMessage.value = error.localizedDescription
            } else {
                Contact.createOrUpdate(json.arrayValue)
            }
        }
    }
    
    private func obsever() {
        RealmNotification.share.observeCollectionChange(collection: Contact.findAll())
    }
    
    private func handleObsever() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactListChange(_:)), name: NSNotification.Name(rawValue: RealmNotificationType.inital.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactListChange(_:)), name: NSNotification.Name(rawValue: RealmNotificationType.update.rawValue), object: nil)
    }
    
    @objc private func handleContactListChange(_ notification: Notification) {
        self.getAllContactFromDB()
    }
    
    public func getAllContactFromDB() {
        self.contacts = Contact.getAllContact()
        self.shouldReloadData.value = true
    }
    
    public func cellViewModel(index: Int) -> ContactViewModel? {
        guard contacts.count > 0 else { return nil }
        let contactViewModel = ContactViewModel()
        contactViewModel.setData(contact: contacts[index])
        return contactViewModel
    }

    public var count: Int {
        return contacts.count
    }
    
}
