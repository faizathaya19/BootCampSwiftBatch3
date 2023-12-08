
import Foundation

struct CheckOutParam: Encodable {
    let address: String
    let items: [itemParam]
    let status: String
    let totalPrice: Int
    let shippingPrice: Int
    let payment: String
    let paymentId: String
    
    enum CodingKeys: String, CodingKey {
        case address, items, status, payment
        case totalPrice = "total_price"
        case shippingPrice = "shipping_price"
        case paymentId = "payment_id"
    }
}

struct itemParam: Encodable {
    let id : String
    let quantity : Int
}



