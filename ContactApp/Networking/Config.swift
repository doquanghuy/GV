//

//

import Foundation

struct Constant {
    static let BASE_URL = "http://gojek-contacts-app.herokuapp.com"

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
    }
    
    struct Segue {
        static let listToDetail = "pushDetailContactSegue"
        static let listToAdd = "pushAddContactSegue"
    }
}
