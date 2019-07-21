//

//

import Foundation
import Alamofire
import SwiftyJSON

class ContactsViewModel {
    var shouldReloadData = Dynamic<Bool>(false)
    var errorMessage = Dynamic<String?>(nil)
    
    private var request: Request?
    private lazy var sections = Group.findAll(realmProvider: self.provider).sorted(byKeyPath: Constant.GroupKeys.sortKey)
    private lazy var sectionsSorted = [[Contact]]()
    private var provider: RealmProvider!
    private var sectionIds = [String]()
    
    init(realmProvider: RealmProvider = RealmProvider()) {
        self.provider = realmProvider
        self.resetSections()
    }

    public func getContactList() {
        self.requestContactList {[weak self] (error, json) in
            if let error = error {
                self?.errorMessage.value = error.localizedDescription
                return
            }
            self?.addContacts(json: json!)
        }
    }
    
    public func requestContactList(completion: ((_ error: Error?, _ json: JSON?) -> Void)?) {
        self.request = APIManager.APIContact.getContacts(completion)
    }
    
    public func addContacts(json: JSON, _ realmProvider: RealmProvider = RealmProvider(), _ completion: (([Contact]) -> Void)? = nil) {
        Contact.createOrUpdate(realmProvider: realmProvider, true, json.arrayValue) {[weak self] contacts in
            DispatchQueue.main.async {
                self?.resetSections()
                self?.shouldReloadData.value = true
                completion?(contacts)
            }
        }
    }
    
    public func resetSections() {
        var res = [[Contact]]()
        var ids = [String]()
        let sections = Group.findAll(realmProvider: self.provider).sorted(byKeyPath: Constant.GroupKeys.sortKey)
        for section in sections {
            res.append(section.contacts.sorted {$0.full_name < $1.full_name})
            ids.append(section.id)
        }
        sectionsSorted = res
        sectionIds = ids
    }
    
    public func cellViewModel(indexPath: IndexPath) -> ContactCellViewModel? {
        guard !sections.isEmpty else { return nil }
        return ContactCellViewModel(contact: sectionsSorted[indexPath.section][indexPath.row])
    }
    
    public func contactViewModel(indexPath: IndexPath) -> ContactViewModel? {
        guard !sections.isEmpty else { return nil }
        return ContactViewModel(contactId: sectionsSorted[indexPath.section][indexPath.row].id, realmProvider: self.provider)
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
