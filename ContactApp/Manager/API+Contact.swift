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
    struct Contact {
        private init() {}
        
        static func getContacts(_ completion: ((NSError?, JSON) -> Void)? = nil) {
            let url = APIManager.apiEndPoint(endPoint: Constant.StringURL.Contact.getContacts)
            APIManager.request(url: url, method: .get, params: [:], completion: completion)
        }
        
        static func getContactDetail(_ contactId: Int, completion: ((NSError?, JSON) -> Void)? = nil) {
            let url = APIManager.apiEndPoint(endPoint: Constant.StringURL.Contact.getContact, "\(contactId)")
            APIManager.request(url: url, method: .get, params: [:], completion: completion)
        }

    }
}
