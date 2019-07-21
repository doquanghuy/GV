//

//

import Foundation
import Alamofire

class ContactsViewModel {
    var shouldReloadData = Dynamic<Bool>(false)
    var errorMessage = Dynamic<String?>(nil)
    
    private var request: Request?
    private lazy var sections = Group.findAll().sorted(byKeyPath: Constant.GroupKeys.sortKey)
    private var sectionsSorted = [[Contact]]()
    private var sectionIds = [String]()
    
    init() {
        self.resetSections()
    }
    
    public func getContactList(){
        self.request = APIManager.APIContact.getContacts {[weak self] (error, json) in
            if let error = error {
                self?.errorMessage.value = error.localizedDescription
            }
            Contact.createOrUpdate(json.arrayValue, completion: {contacts in
                DispatchQueue.main.async {
                    self?.resetSections()
                    self?.shouldReloadData.value = true
                }
            })
        }
    }
    
    public func resetSections() {
        var res = [[Contact]]()
        var ids = [String]()
        let sections = Group.findAll().sorted(byKeyPath: Constant.GroupKeys.sortKey)
        for section in sections {
            res.append(section.contacts.sorted {$0.full_name < $1.full_name})
            ids.append(section.id)
        }
        sectionsSorted = res
        sectionIds = ids
    }
    
    public func sortContact(contact1: Contact, and contact2: Contact) -> Bool {
        return contact1.full_name < contact2.full_name
    }
    
    public func cellViewModel(indexPath: IndexPath) -> ContactCellViewModel? {
        guard !sections.isEmpty else { return nil }
        return ContactCellViewModel(contact: sectionsSorted[indexPath.section][indexPath.row])
    }
    
    public func contactViewModel(indexPath: IndexPath) -> ContactViewModel? {
        guard !sections.isEmpty else { return nil }
        return ContactViewModel(contactId: sectionsSorted[indexPath.section][indexPath.row].id, at: indexPath)
    }
    public func numberOfRowsInSections(_ section: Int) -> Int {
        return sectionsSorted[section].count
    }
    
    public func sectionNumber() -> Int {
        return sectionsSorted.count
    }
    
    public func titleForHeader(_ section: Int) -> String {
        return sectionIds[section]
    }
    
    public func sectionIndexTitles() -> [String] {
        return sectionIds
    }
    
    public func loadDbStatus() -> Bool {
        return self.sections.count > 0
    }
    
    deinit {
        self.request?.cancel()
    }
}
