import Foundation

struct ResponseCategoryModel: Codable {
    let meta: Meta
    let data: DataCategoryClass
}

// MARK: - DataClass
struct DataCategoryClass: Codable {
    let data: [CategoryModel]
}
