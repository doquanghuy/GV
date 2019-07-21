//

//

import Foundation
import Alamofire
import SwiftyJSON

class ContactViewModel {
    private var detailRequest: Request?
    private var favoriteRequest: Request?
    private var contactId: Int!
    
    var shouldReloadData = Dynamic<Bool>(false)
    var fullName = Dynamic<String>(Constant.String.empty)
    var errorMessage = Dynamic<String?>(nil)
    var updateErrorMessage = Dynamic<String?>(nil)
    var email = Dynamic<String?>(nil)
    var phoneNumber = Dynamic<String?>(nil)
    var urlProfilPic = Dynamic<String?>(nil)
    var favorite = Dynamic<Bool>(false)
    var didUpdateContact = Dynamic<Bool>(false)
    var provider: RealmProvider!
    
    init(contactId: Int, realmProvider: RealmProvider = RealmProvider()) {
        self.provider = realmProvider
        self.contactId = contactId
    }
    
    public func getDetailContact() {
        self.getDetailContact {[weak self] (error, json) in
            if let error = error {
                self?.errorMessage.value = error.localizedDescription
                return
            }
            self?.updateData(json: json!, completion: nil)
        }
    }
    
    public func getDetailContact(completion: ((_ error: Error?, _ json: JSON?) -> Void)? = nil) {
        self.detailRequest = APIManager.APIContact.getContactDetail(contactId, completion: completion)
    }
    
    public func updateData(json: JSON, completion: ((_ contact: Contact?) -> Void)? = nil) {
        Contact.createOrUpdate(realmProvider: self.provider, true, json, {[weak self] contact in
            self?.reloadData()
            completion?(contact)
        })
    }
    
    func contact() -> Contact? {
        return Contact.findByID(id: contactId, realmProvider: self.provider)
    }
    
    func reloadData() {
        guard let contact = contact() else {return}
        fullName.value = contact.full_name
        email.value = contact.email
        phoneNumber.value = contact.phone_number
        urlProfilPic.value = contact.profile_pic
        favorite.value = contact.favorite
        didUpdateContact.value = true
    }
    
    public func updateContact(favorite: Bool) {
        self.updateContact(favorite: favorite, contactId: contactId) {[weak self] (error, json) in
            guard let this = self else {return}
            if let error = error {
                this.updateErrorMessage.value = error.localizedDescription
                return
            }
            this.updateData(json: json!, completion: nil)
        }
    }
    
    public func updateContact(favorite: Bool, contactId: Int, completion: ((_ error: Error?, _ json: JSON?) -> Void)? = nil) {
        let params: [String: Any] = [Constant.ContactKeys.favorite: favorite]
        self.favoriteRequest = APIManager.APIContact.updateContact(contactId, params: params, completion: completion)
    }
    
    deinit {
        self.detailRequest?.cancel()
        self.favoriteRequest?.cancel()
    }
}
