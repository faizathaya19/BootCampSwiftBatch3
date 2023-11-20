import Foundation

struct GalleryModel: Codable {
    let id: Int
    let productsId: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case productsId = "products_id"
    }
}
