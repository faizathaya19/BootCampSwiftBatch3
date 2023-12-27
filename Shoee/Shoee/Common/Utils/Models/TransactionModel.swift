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
    let items: [ItemTransactionModel]
    
    enum CodingKeys: String, CodingKey {
        case id, address, status, payment, items
        case paymentId = "payment_id"
        case usersId = "users_id"
        case shippingPrice = "shipping_price"
        case totalPrice = "total_price"
    }
}

struct ItemTransactionModel: Codable {
    let id: Int
    let usersId: Int
    let productsId: Int
    let transactionsId: Int
    let quantity: Int
    let product: ProductModel

    
    enum CodingKeys: String, CodingKey {
        case id, quantity, product
        case usersId = "users_id"
        case productsId = "products_id"
        case transactionsId = "transactions_id"
    }
}
