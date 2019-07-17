//

//

struct Constant {
    static let BASE_URL = "http://gojek-contacts-app.herokuapp.com"
}

extension Constant {
    struct StringURL {
        private init() {}
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

