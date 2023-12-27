import Foundation

struct DataClassModel: Codable {
    let accessToken: String
    let message: String?
    let user: UserModel

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user, message
    }
}
