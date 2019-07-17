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
        
//        static func loadStates(_ countryId: Int, completion: ((NSError?, JSON) -> Void)? = nil) {
//            let params: [String: Any] = ["country_id": countryId]
//            let url = MGAPIManager.apiEndPoint(endPoint: MGConstant.StringURL.Country.fetchCountryStages)
//            MGAPIManager.request(url: url, method: .post, params: params, completion: completion)
//        }
    }
}
