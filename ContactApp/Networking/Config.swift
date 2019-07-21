//

//

import Foundation
import RealmSwift

struct Configuration {
    static let BASE_URL = "http://gojek-contacts-app.herokuapp.com"
}

struct RealmProvider {
    let configuration: Realm.Configuration
    
    internal init(config: Realm.Configuration = Realm.Configuration()) {
        configuration = config
    }
    
    var realm: Realm {
        return try! Realm(configuration: configuration)
    }
}
