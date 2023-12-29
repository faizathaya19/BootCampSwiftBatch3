
import Foundation

struct BCAParam: Encodable {
    let payment_type: String = "bank_transfer"
    let transactionDetails: transactionDetails
    let bankTransfer: bankTransfer
    let customerDetails: customerDetails
    let itemDetails: [itemDetails]
    
    enum CodingKeys: String, CodingKey {
        case payment_type
        case transactionDetails = "transaction_details"
        case bankTransfer = "bank_transfer"
        case customerDetails = "customer_details"
        case itemDetails = "item_details"
    }
}

struct transactionDetails: Encodable {
    let orderId: String
    let grossAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case grossAmount = "gross_amount"
    }
}

struct bankTransfer: Encodable {
    let bank : String
    let vaNumber : String
    
    enum CodingKeys: String, CodingKey {
        case bank
        case vaNumber = "va_number"
    }
}

struct itemDetails: Encodable {
    let id : String
    let price : Int
    let quantity : Int
    let name : String
}

struct customerDetails: Encodable {
    let email : String
    let firstName : String
    let lastName : String
    let phone : String
    
    enum CodingKeys: String, CodingKey {
        case email, phone
        case firstName = "first_name"
        case lastName = "last_name"
    }
}




