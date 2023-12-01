import Foundation
import Alamofire

enum PaymentGateWayEndPoint {
    case vaBCA(BCAParam)

    func path() -> String {
        switch self {
        case .vaBCA:
            return "/v2/charge"
        }
    }

    func method() -> HTTPMethod {
        return .post
    }

    var parameters: [String: Any]? {
        switch self {
           case .vaBCA(let bcaParam):
            return try? bcaParam.asDictionary()
        }
    }

    var headers: [String: String]? {
        switch self {
        case .vaBCA:
            let base64Key = base64EncodedServerKey()
            return [
                "Accept": "application/json",
                "Authorization": "Basic \(base64Key)",
                "Content-Type": "application/json"
            ]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .vaBCA:
            return JSONEncoding.default
        }
    }

    func urlString() -> String {
        return BaseConstant.baseUrl + self.path()
    }

    struct BaseConstant {
        static let baseUrl = "https://api.sandbox.midtrans.com"
    }

    private func base64EncodedServerKey() -> String {
        let serverKey = "SB-Mid-server-9Av9Mftg6i_0P8RGQOxJbHWZ"
        if let apiKeyData = serverKey.data(using: .utf8) {
            return apiKeyData.base64EncodedString()
        } else {
            fatalError("Failed to convert API key to data.")
        }
    }
}
