//

//

import Foundation

class ContactsViewModel {
    
    var contacts = Dynamic<[Contact]>([])
    
    public func getContactList(completion: (() -> Void)?, errorCompletion: ((_ messages: String?) -> Void)?){
        APIManager.Contact.getContacts { (error, json) in
            if let error = error {
                errorCompletion?(error.localizedDescription)
            } else {
                for jsonItem in json.arrayValue {
                    Contact.createOrUpdate(jsonItem)
                }
                completion?()
            }
        }
    }
    
    public func getAllContactFromDB() {
        self.contacts.value = Contact.getAllContact()
    }
    
    public func cellViewModel(index: Int) -> ContactViewModel? {
        guard contacts.value.count > 0 else { return nil }
        let contactViewModel = ContactViewModel()
        contactViewModel.setData(contact: contacts.value[index])
        return contactViewModel
    }

    public var count: Int {
        return contacts.value.count
    }
    
}
