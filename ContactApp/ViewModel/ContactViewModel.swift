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
    var fullName = Dynamic<String>(Constant.String.empty)
    var errorMessage = Dynamic<String?>(nil)
    var updateErrorMessage = Dynamic<String?>(nil)
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
                return
            }
            Contact.createOrUpdate(json, completion: {_ in
                self?.reloadData()
            })
        }
    }
    
    func reloadData() {
        guard let contact = Contact.findByID(id: contactId) else {return}
        fullName.value = contact.full_name
        email.value = contact.email
        phoneNumber.value = contact.phone_number
        urlProfilPic.value = contact.profile_pic
        favorite.value = contact.favorite
        didUpdateContact.value = indexPath
    }
    
    public func updateContact(favorite: Bool) {
        guard let contact = Contact.findByID(id: contactId) else {return}
        let params: [String: Any] = [Constant.ContactKeys.favorite: favorite]
        self.favoriteRequest = APIManager.APIContact.updateContact(contact.id, params: params){[weak self] (error, json) in
            if let error = error {
                self?.updateErrorMessage.value = error.localizedDescription
                return
            }
            Contact.createOrUpdate(json, completion: {_ in
                self?.reloadData()
            })
        }
    }
    
    deinit {
        self.detailRequest?.cancel()
        self.favoriteRequest?.cancel()
    }
}
