import Foundation

struct CheackOutModel: Codable {
    let address: String
    let items: [ItemModel]
    let status: String
    let totalPrice: Int
    let shippingPrice: Int
    
    enum CodingKeys: String, CodingKey {
        case address, items, status
        case totalPrice = "total_price"
        case shippingPrice = "shipping_price"
    }
}
