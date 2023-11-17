import Foundation

struct User: Codable {
    let id: Int
    let name, email, username: String
    let profilePhotoURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, username
        case profilePhotoURL = "profile_photo_url"
    }
}
