import Foundation

struct MessageModel {
    let id: String
    let data: MessageData
    
    struct MessageData {
        let createdAt: String
        let isFromUser: Bool
        let message: String
        let userId: Int
        let username: String
        let imageProfile: String
        let product: MessageProduct?
        
        struct MessageProduct {
            let productId: Int?
            let productName: String?
            let price: Int?
            let image: String?
        }
    }
}
