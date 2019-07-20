//
//  API+Contact.swift
//  ContactApp
//
//  Created by Quang Huy on 7/17/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension APIManager {
    struct APIContact {
        private init() {}
        
        static func getContacts(_ completion: ((NSError?, JSON) -> Void)? = nil) -> Request? {
            let url = APIManager.apiEndPoint(endPoint: Constant.StringURL.Contact.getContacts)
            return APIManager.request(url: url, method: .get, params: [:], completion: completion)
        }
        
        static func getContactDetail(_ contactId: Int, completion: ((NSError?, JSON) -> Void)? = nil) -> Request? {
            let url = APIManager.apiEndPoint(endPoint: Constant.StringURL.Contact.getContact, "\(contactId)")
            return APIManager.request(url: url, method: .get, params: [:], completion: completion)
        }
        
        static func createContact(_ contact: Contact, completion: ((NSError?, JSON) -> Void)? = nil) -> Request? {
            let url = APIManager.apiEndPoint(endPoint: Constant.StringURL.Contact.addContact)
            let params: [String: Any] = ["first_name": contact.first_name,
                                         "last_name": contact.last_name,
                                         "email": contact.email ?? "",
                                         "phone_number": contact.phone_number ?? "",
                                         "favorite": false]
            return APIManager.request(url: url, method: .post, params: params, completion: completion)
        }
        
        static func updateContact(_ contactId: Int, params: [String: Any], completion: ((NSError?, JSON) -> Void)? = nil) -> Request? {
            let url = APIManager.apiEndPoint(endPoint: Constant.StringURL.Contact.updateContact, "\(contactId)")
            return APIManager.request(url: url, method: .put, params: params, completion: completion)
        }

    }
}

