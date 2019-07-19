//
//  API+Contact.swift
//  ContactApp
//
//  Created by Ha Ho on 7/17/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import Foundation
import SwiftyJSON

extension APIManager {
    struct APIContact {
        private init() {}
        
        static func getContacts(_ completion: ((NSError?, JSON) -> Void)? = nil) {
            let url = APIManager.apiEndPoint(endPoint: Constant.StringURL.Contact.getContacts)
            APIManager.request(url: url, method: .get, params: [:], completion: completion)
        }
        
        static func getContactDetail(_ contactId: Int, completion: ((NSError?, JSON) -> Void)? = nil) {
            let url = APIManager.apiEndPoint(endPoint: Constant.StringURL.Contact.getContact, "\(contactId)")
            APIManager.request(url: url, method: .get, params: [:], completion: completion)
        }
        
        static func createContact(_ contact: Contact, completion: ((NSError?, JSON) -> Void)? = nil) {
            let url = APIManager.apiEndPoint(endPoint: Constant.StringURL.Contact.addContact)
            let params: [String: Any] = ["first_name": contact.first_name,
            "last_name": contact.last_name,
            "email": contact.email ?? "",
            "phone_number": contact.phone_number ?? "",
            "favorite": false]
            APIManager.request(url: url, method: .post, params: params, completion: completion)
        }

    }
}
