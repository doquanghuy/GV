//

//

import Foundation
import Alamofire

class ContactsViewModel {
    var shouldReloadData = Dynamic<Bool>(false)
    var errorMessage = Dynamic<String?>(nil)
    
    private var request: Request?
    private lazy var sections = Group.findAll().sorted(byKeyPath: "id")

    init() {
        obsever()
        handleObsever()
    }
    
    public func getContactList(){
        self.request = APIManager.APIContact.getContacts {[weak self] (error, json) in
            if let error = error {
                self?.errorMessage.value = error.localizedDescription
            } else {
                Contact.createOrUpdate(json.arrayValue)
            }
        }
    }
    
    private func obsever() {
        RealmNotification.share.observeCollectionChange(collection: sections)
    }
    
    private func handleObsever() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactListChange(_:)), name: NSNotification.Name(rawValue: RealmNotificationType.inital.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactListChange(_:)), name: NSNotification.Name(rawValue: RealmNotificationType.update.rawValue), object: nil)
    }
    
    @objc private func handleContactListChange(_ notification: Notification) {
        self.shouldReloadData.value = true
    }
    
    public func cellViewModel(indexPath: IndexPath) -> ContactCellViewModel? {
        guard !sections.isEmpty else { return nil }
        return ContactCellViewModel(contact: sections[indexPath.section].contacts[indexPath.row])
    }
    
    public func contactViewModel(indexPath: IndexPath) -> ContactViewModel? {
        guard !sections.isEmpty else { return nil }
        return ContactViewModel(contact: sections[indexPath.section].contacts[indexPath.row])
    }
    
    public func titleForHeader(_ section: Int) -> String {
        return sections[section].id
    }
    
    public func numberOfRowsInSections(_ section: Int) -> Int {
        return sections[section].contacts.count
    }
    
    public var sectionNumber: Int {
        return sections.count
    }
    
    deinit {
        self.request?.cancel()
    }
}
