import Foundation

struct ResponseCheckOut: Codable {
    let meta: Meta
    let data: DataCheckOutClass
}

// MARK: - DataClass
struct DataCheckOutClass: Codable {
    let data: [CheckOutModel]
}
