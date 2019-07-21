//
//  AddContactViewModel.swift
//  ContactApp
//
//  Created by Quang Huy on 7/19/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddContactViewModel {
    var errorMessage = Dynamic<String?>(nil)
    var didAddContact = Dynamic<Bool>(true)
    
    private var tempContact = Contact()
    private var request: Request?
    private var provider: RealmProvider!
    
    init(realmProvider: RealmProvider = RealmProvider()) {
        self.provider = realmProvider
    }
    
    func setFirstName(name: String?) {
        self.tempContact.first_name = name ?? Constant.String.empty
    }
    
    func setLastName(name: String?) {
        self.tempContact.last_name = name ?? Constant.String.empty
    }
    
    func setEmail(email: String?) {
        self.tempContact.email = email
    }
    
    func setMobile(mobile: String?) {
        self.tempContact.phone_number = mobile
    }
    
    func createContact(contact: Contact, completion: ((_ error: Error?, _ json: JSON?) -> Void)? = nil) {
        self.request = APIManager.APIContact.createContact(contact, completion: completion)
    }
    
    func createContactLocal(json: JSON, completion: ((_ contact: Contact?) -> Void)? = nil) {
        Contact.createOrUpdate(realmProvider: self.provider, true, json) {[weak self] (contact) in
            self?.didAddContact.value = true
            completion?(contact)
        }
    }
    
    func createContact() {
        self.createContact(contact: tempContact) {[weak self] (error, json) in
            if let error = error {
                self?.errorMessage.value = error.localizedDescription
                return
            }
            self?.createContactLocal(json: json!, completion: nil)
        }
    }
    
    deinit {
        self.request?.cancel()
    }
}
