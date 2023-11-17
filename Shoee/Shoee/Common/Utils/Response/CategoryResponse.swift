import Foundation

struct ResponseCategoryModel: Codable {
    let meta: Meta
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let data: [CategoryModel]
}
