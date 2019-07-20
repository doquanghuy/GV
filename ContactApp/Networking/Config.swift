//

//

import Foundation

struct Constant {
    static let BASE_URL = "http://gojek-contacts-app.herokuapp.com"
}

extension Constant {
    struct StringURL {
        private init() {}
    }
    
    struct ConcurrentQueue {
        static let queue = DispatchQueue.global(qos: .background)
    }
    
    struct String {
        static let defaultContactName = "#"
    }
}

// MARK: - Authen
extension Constant.StringURL {
    struct Contact {
        private init() {}
        
        static let getContacts = "/contacts.json"
        static let getContact = "/contacts/%@.json"
        static let addContact = "/contacts.json"
        static let updateContact = "/contacts/%@.json"
        static let deleteContact = "/contacts/%@.json"
        
    }
}
