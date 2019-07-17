//
//  APIServices.swift
//

import Foundation

enum APIServices {
    case getContacts()
    case getContact(contactId: Int)
    case addContact(
        first_name: String,
        last_name: String,
        email: String?,
        phone_number: String?)
    
    case updateContact(
        id: Int,
        first_name: String,
        last_name: String,
        email: String?,
        phone_number: String?,
        favorite: Bool
    )
    
    case deleteContact(contactId: Int)
}

extension APIServices: EndpointType {
    var baseURL: URL {
        return URL(string: BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getContacts:
            return "/contacts.json"
        case .getContact(let id):
            return "/contacts/\(id).json"
        case .addContact( _):
            return "/contacts.json"
        case .updateContact(let id, _, _, _, _, _):
            return "/contacts/\(id).json"
        case .deleteContact(let id):
            return "/contacts/\(id).json"
        }
    }
    
    var method: String {
        switch self {
        case .getContacts:
            return "GET"
        case .getContact( _):
            return "GET"
        case .addContact( _):
            return "POST"
        case .updateContact( _):
            return "PUT"
        case .deleteContact( _):
            return "DELETE"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getContacts:
            return [:]
        case .getContact( _):
            return [:]
        case .addContact(let first_name,
                         let last_name,
                         let email,
                         let phone_number):
            return [
                "first_name": first_name,
                "last_name": last_name,
                "email": email ?? "",
                "phone_number": phone_number ?? "",
                "favorite": false
            ]
        case .updateContact( _,
                             let first_name,
                             let last_name,
                             let email,
                             let phone_number,
                             let favorite):
            return [
                "first_name": first_name,
                "last_name": last_name,
                "email": email ?? "",
                "phone_number": phone_number ?? "",
                "favorite": favorite
            ]
        case .deleteContact( _):
            return [:]
        }
    }
}
