import Foundation

struct TransactionModel: Codable {
    let id: Int
    let usersId: Int
    let address: String
    let totalPrice: Int
    let shippingPrice: Int
    let status: String
    let payment: String
    let paymentId: String
    
    enum CodingKeys: String, CodingKey {
        case id, address, status, payment
        case paymentId = "payment_id"
        case usersId = "users_id"
        case shippingPrice = "shipping_price"
        case totalPrice = "total_price"
    }
}
