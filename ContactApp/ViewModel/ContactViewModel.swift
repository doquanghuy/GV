//

//

import Foundation
import Alamofire

class ContactViewModel {
    private var detailRequest: Request?
    private var favoriteRequest: Request?
    private var indexPath: IndexPath!
    private var contactId: Int!
    
    var shouldReloadData = Dynamic<Bool>(false)
    var errorMessage = Dynamic<String?>(nil)
    var updateErrorMessage = Dynamic<String?>(nil)
    var fullName = Dynamic<String>("")
    var email = Dynamic<String?>(nil)
    var phoneNumber = Dynamic<String?>(nil)
    var urlProfilPic = Dynamic<String?>(nil)
    var favorite = Dynamic<Bool>(false)
    var didUpdateContact = Dynamic<IndexPath>(IndexPath())
    
    init(contactId: Int, at indexPath: IndexPath) {
        self.contactId = contactId
        self.indexPath = indexPath
    }
    
    public func getDetailContact() {
        self.detailRequest = APIManager.APIContact.getContactDetail(contactId) {[weak self] (error, json) in
            if let error = error {
                self?.errorMessage.value = error.localizedDescription
            } else {
                Contact.createOrUpdate(json)
            }
        }
    }
    
    func reloadData() {
        guard let contact = Contact.findByID(id: contactId) else {return}
        fullName.value = "\(contact.first_name) \(contact.last_name)"
        email.value = contact.email
        phoneNumber.value = contact.phone_number
        urlProfilPic.value = contact.profile_pic
        favorite.value = contact.favorite
        didUpdateContact.value = indexPath
    }
    
    public func updateContact(favorite: Bool) {
        guard let contact = Contact.findByID(id: contactId) else {return}
        let params: [String: Any] = ["favorite": favorite]
        self.favoriteRequest = APIManager.APIContact.updateContact(contact.id, params: params){[weak self] (error, json) in
            if let error = error {
                self?.updateErrorMessage.value = error.localizedDescription
            } else {
                Contact.createOrUpdate(json, completion: {c in
                    self?.reloadData()
                })
            }
        }
    }
    
    deinit {
        self.detailRequest?.cancel()
        self.favoriteRequest?.cancel()
    }
}
