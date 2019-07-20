//
//  AddContactViewModel.swift
//  ContactApp
//
//  Created by Quang Huy on 7/19/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import UIKit
import Alamofire

class AddContactViewModel {
    
    var errorMessage = Dynamic<String?>(nil)
    var success = Dynamic<Bool>(false)
    
    private var tempContact = Contact()
    private var request: Request?
    func setFirstName(name: String?) {
        self.tempContact.first_name = name ?? ""
    }
    
    func setLastName(name: String?) {
        self.tempContact.last_name = name ?? ""
    }
    
    func setEmail(email: String?) {
        self.tempContact.email = email
    }
    
    func setMobile(mobile: String?) {
        self.tempContact.phone_number = mobile
    }
    
    func createContact() {
        self.request = APIManager.APIContact.createContact(tempContact) {[weak self] (error, json) in
            if let error = error {
                self?.errorMessage.value = error.localizedDescription
            } else {
                self?.success.value = true
                Contact.createOrUpdate(json)
            }
        }
    }
    
    deinit {
        self.request?.cancel()
    }
}
