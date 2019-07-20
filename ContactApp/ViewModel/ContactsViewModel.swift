//

//

import Foundation
import Alamofire

class ContactsViewModel {
    var shouldReloadData = Dynamic<Bool>(false)
    var errorMessage = Dynamic<String?>(nil)
    
    private var request: Request?
    private lazy var sections = Group.findAll().sorted(byKeyPath: Constant.ContactKeys.id)
    
    public func getContactList(){
        self.request = APIManager.APIContact.getContacts {[weak self] (error, json) in
            if let error = error {
                self?.errorMessage.value = error.localizedDescription
            } else {
                Contact.createOrUpdate(json.arrayValue, completion: {contacts in
                    self?.shouldReloadData.value = true
                })
            }
        }
    }
    
    public func cellViewModel(indexPath: IndexPath) -> ContactCellViewModel? {
        guard !sections.isEmpty else { return nil }
        return ContactCellViewModel(contact: sections[indexPath.section].contacts[indexPath.row])
    }
    
    public func contactViewModel(indexPath: IndexPath) -> ContactViewModel? {
        guard !sections.isEmpty else { return nil }
        return ContactViewModel(contactId: sections[indexPath.section].contacts[indexPath.row].id, at: indexPath)
    }
    
    public func titleForHeader(_ section: Int) -> String {
        return sections[section].id
    }
    
    public func numberOfRowsInSections(_ section: Int) -> Int {
        return sections[section].contacts.count
    }
    
    public func sectionNumber() -> Int {
        return sections.count
    }
    
    public func sectionIndexTitles() -> [String] {
        return sections.map { $0.id}
    }
    
    deinit {
        self.request?.cancel()
    }
}
