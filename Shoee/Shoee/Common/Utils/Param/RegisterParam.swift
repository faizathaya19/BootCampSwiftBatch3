import Foundation

struct RegisterParam: Encodable {
    let name: String
    let username: String
    let email: String
    let password: String
}
