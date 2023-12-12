struct BCAResponse: Codable {
    let currency: String?
    let expiryTime: String?
    let fraudStatus: String?
    let grossAmount: String?
    let merchantId: String?
    let orderId: String?
    let paymentType: String?
    let statusCode: String?
    let statusMessage: String?
    let transactionId: String?
    let transactionStatus: String?
    let transactionTime: String?
    let vaNumbers: [VANumber]

    struct VANumber: Codable {
        let bank: String?
        let vaNumber: String?

        private enum CodingKeys: String, CodingKey {
            case bank
            case vaNumber = "va_number"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case currency
        case expiryTime = "expiry_time"
        case fraudStatus = "fraud_status"
        case grossAmount = "gross_amount"
        case merchantId = "merchant_id"
        case orderId = "order_id"
        case paymentType = "payment_type"
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case transactionId = "transaction_id"
        case transactionStatus = "transaction_status"
        case transactionTime = "transaction_time"
        case vaNumbers = "va_numbers"
    }
}
