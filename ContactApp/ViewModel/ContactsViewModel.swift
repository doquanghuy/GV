//

//

import Foundation

class ContactsViewModel {
    var shouldReloadData = Dynamic<Bool>(false)
    var errorMessage = Dynamic<String?>(nil)
    private lazy var resultContact = Contact.findAll()
    
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
        RealmNotification.share.observeCollectionChange(collection: resultContact)
    }
    
    private func handleObsever() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactListChange(_:)), name: NSNotification.Name(rawValue: RealmNotificationType.inital.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactListChange(_:)), name: NSNotification.Name(rawValue: RealmNotificationType.update.rawValue), object: nil)
    }
    
    @objc private func handleContactListChange(_ notification: Notification) {
        self.shouldReloadData.value = true
    }
        
    public func cellViewModel(index: Int) -> ContactCellViewModel? {
        guard resultContact.count > 0 else { return nil }
        return ContactCellViewModel(contact: resultContact[index])
    }

    public var count: Int {
        return resultContact.count
    }
    
}
