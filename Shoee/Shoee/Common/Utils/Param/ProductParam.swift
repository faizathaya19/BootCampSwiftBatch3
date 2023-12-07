import Foundation

struct ProductParam: Encodable {
    var id: Int?
    var limit: Int?
    var name: String?
    var description: String?
    var priceFrom: Int?
    var priceTo: Int?
    var tags: String?
    var categories: Int?
    var page: Int?
}
