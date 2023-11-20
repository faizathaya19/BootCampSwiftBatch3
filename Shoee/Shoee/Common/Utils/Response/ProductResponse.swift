import Foundation

struct ResponseProductModel: Codable {
    let meta: Meta
    let data: DataProductClass
}

// MARK: - DataClass
struct DataProductClass: Codable {
    let data: [ProductModel]
}
