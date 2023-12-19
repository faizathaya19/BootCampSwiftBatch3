import Foundation

struct TransactionResponse: Codable {
    let meta: Meta
    let data: DataTransactionClass
}

// MARK: - DataClass
struct DataTransactionClass: Codable {
    let data: [TransactionModel]
}
