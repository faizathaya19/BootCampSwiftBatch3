import Foundation

struct RegisterModel: Encodable {
    let name: String
    let username: String
    let email: String
    let password: String
}


struct ResponseModel: Codable {
    let meta: Meta
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let accessToken, tokenType: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user
    }
}

// MARK: - User
struct User: Codable {
    let id: Int
    let name, email, username: String
    let profilePhotoURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, username
        case profilePhotoURL = "profile_photo_url"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let code: Int
    let status, message: String
}
