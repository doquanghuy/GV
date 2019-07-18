//
//  ContactCellViewModel.swift
//  ContactApp
//
//  Created by Ha Ho on 7/18/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import UIKit

class ContactCellViewModel {
    private var contact: Contact?
    
    var fullName = Dynamic<String>("")
    var urlProfilPic = Dynamic<String?>(nil)
    var favorite = Dynamic<Bool>(false)
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    func reloadData() {
        guard let contact = contact else { return }
        fullName.value = "\(contact.first_name) \(contact.last_name)"
        urlProfilPic.value = contact.profile_pic
        favorite.value = contact.favorite
    }
}
