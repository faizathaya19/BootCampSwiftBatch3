import Foundation

struct ResponseProductModel: Codable {
    let meta: Meta
    let data: DataProductClass
}

struct DataProductClass: Codable {
    let data: [ProductModel]
    let lastPage: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case lastPage = "last_page"
    }
}
