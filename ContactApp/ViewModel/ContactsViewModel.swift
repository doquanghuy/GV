//

//

import Foundation

class ContactsViewModel {
    
    private var contacts: [Contact] = []
    
    public func getContactList(completion: (() -> Void)?, errorCompletion: ((_ messages: String?) -> Void)?){
        APIManager.Contact.getContacts { (error, json) in
            if let error = error {
                errorCompletion?(error.localizedDescription)
            } else {
                for jsonItem in json.arrayValue {
                    Contact.createOrUpdate(jsonItem)
                    if let contact = Contact.findByID(id: jsonItem["id"].intValue) {
                        self.contacts.append(contact)
                    }
                }
                completion?()
            }
        }
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
