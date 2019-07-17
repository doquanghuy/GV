//

//

import Foundation

struct Contact: Codable {
    let id: Int
    var first_name: String
    var last_name: String
    var profile_pic: String
    var favorite: Bool
    var email: String?
    var phone_number: String?
}
