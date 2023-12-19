import Foundation

struct UserModel: Codable {
    let id: Int
    let name, email, username: String
    let profilePhotoURL: String
    let phone: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, username, phone
        case profilePhotoURL = "profile_photo_url"
    }
}
