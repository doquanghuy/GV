//

//

import Foundation

class ContactsViewModel {
    
    private let networking = Networking()
    
    private var contacts: [Contact]?
    
    public func getContactList(completion: (() -> Void)?, errorCompletion: ((_ messages: String?) -> Void)?){
        networking.performNetworkTask(endpoint: APIServices.getContacts(), type: [Contact].self, completion: { (response) in
            self.contacts = response
            completion?()
        }) { (errorMessages) in
            errorCompletion?(errorMessages)
        }
    }
    
    public func cellViewModel(index: Int) -> ContactViewModel? {
        guard let contacts = contacts else { return nil }
        
        let contactViewModel = ContactViewModel()
        
        contactViewModel.setData(contact: contacts[index])

        return contactViewModel
    }

    public var count: Int {
        return contacts?.count ?? 0
    }
    
}
