import Foundation
import Alamofire

enum PaymentGateWayEndPoint {
    case va(BCAParam)
    case transactionStatus(paymentID: String)
    case cancelPayment(paymentID: String)

    func path() -> String {
        switch self {
        case .va:
            return "/v2/charge"
        case .transactionStatus(paymentID: let paymentID):
            return "/v2/\(paymentID)/status"
        case .cancelPayment(paymentID: let paymentID):
            return "/v2/\(paymentID)/cancel"
        }
    }

    func method() -> HTTPMethod {
        switch self {
        case .va(let bcaParam):
            return .post
        case .cancelPayment:
            return .post
        case .transactionStatus:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
           case .va(let bcaParam):
            return try? bcaParam.asDictionary()
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        switch self {
        case .va, .transactionStatus, .cancelPayment:
            let base64Key = base64EncodedServerKey()
            return [
                "Accept": "application/json",
                "Authorization": "Basic \(base64Key)",
                "Content-Type": "application/json"
            ]
        }
    }

    var encoding: ParameterEncoding {
          return JSONEncoding.default
      }

    func urlString() -> String {
        return BaseConstant.baseUrl + self.path()
    }

    struct BaseConstant {
        static let baseUrl = Constants.midtransUrl
    }

    private func base64EncodedServerKey() -> String {
        let serverKey = Constants.midtransKey
        if let apiKeyData = serverKey.data(using: .utf8) {
            return apiKeyData.base64EncodedString()
        } else {
            fatalError("Failed to convert API key to data.")
        }
    }
}
