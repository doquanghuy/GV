
//
//  Constant.swift
//  ContactApp
//
//  Created by Quang Huy on 7/20/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import UIKit

struct Constant {
    struct StringURL {
        struct Contact {
            static let getContacts = "/contacts.json"
            static let getContact = "/contacts/%@.json"
            static let addContact = "/contacts.json"
            static let updateContact = "/contacts/%@.json"
            static let deleteContact = "/contacts/%@.json"
        }
    }
    
    struct ConcurrentQueue {
        static let queue = DispatchQueue.global(qos: .background)
    }
    
    struct String {
        static let defaultContactName = "#"
        static let empty = ""
        static let sortKeyDefault = "ZZ"
    }
    
    struct Segue {
        static let listToDetail = "pushDetailContactSegue"
        static let listToAdd = "pushAddContactSegue"
    }
    
    struct Image {
        static let placeHolder = "placeholder_photo"
    }
    
    struct TableViewCell {
        static let listCell = "ContactCell"
    }
    
    struct ContactKeys {
        static let id = "id"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let profilePic = "profile_pic"
        static let favorite = "favorite"
        static let email = "email"
        static let phoneNumber = "phone_number"
        static let fullName = "full_name"
    }
    
    struct GroupKeys {
        static let id = "id"
        static let contacts = "contacts"
        static let contactSorted = "contactSorted"
        static let sortKey = "sortKey"
    }
    
    struct Color {
        static let greenColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha: 1.0)
        static let gradientColors = [UIColor.white.cgColor, UIColor(red: 0.31, green: 0.89, blue: 0.76, alpha: 0.3).cgColor]
    }
}
