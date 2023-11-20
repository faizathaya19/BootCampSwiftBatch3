import Foundation

struct ProductModel: Codable {
    let id: Int
    let name: String
    let price: Int
    let description: String
    let tags: String?
    let categoriesId: Int
    let category: CategoryModel
    let galleries: [GalleryModel]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, description, tags, category, galleries
        case categoriesId = "categories_id"
    }
}
