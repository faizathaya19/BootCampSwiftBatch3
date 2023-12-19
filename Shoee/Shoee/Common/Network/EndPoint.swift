import Foundation
import Alamofire

enum EndPoint {
    case register(RegisterParam)
    case login(LoginParam)
    case logout(vc: UIViewController)
    case categories
    case products(ProductParam)
    case user
    case checkout(CheckOutParam)
    case deleteCheckout(paymentId: String)
    case transactions
    
    func path() -> String {
        switch self {
        case .register:
            return "/register"
        case .login:
            return "/login"
        case .logout:
            return "/logout"
        case .categories:
            return "/categories"
        case .products:
            return "/products"
        case .user:
            return "/user"
        case .checkout:
            return "/checkout"
        case .deleteCheckout(paymentId: let paymentId):
            return "/transactions/\(paymentId)"
        case .transactions:
            return "/transactions"
            
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .register, .login, .logout, .checkout, .deleteCheckout:
            return .post
        case .categories, .products, .user, .transactions:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .register(let params):
            return try? params.asDictionary()
        case .login(let params):
            return try? params.asDictionary()
        case .products(let params):
            return try? params.asDictionary()
        case .checkout(let params):
            return try? params.asDictionary()
            
        default:
            return nil
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .register:
            return ["Accept": "application/json"]
        case .logout, .user, .checkout, .deleteCheckout, .transactions:
            return ["Accept": "application/json", "Authorization": "Bearer \(TokenService.shared.retrieveToken())"]
        default:
            return nil
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch self {
        case .register, .login, .categories, .products, .user, .transactions:
            return URLEncoding.queryString
        default: return JSONEncoding.default
        }
    }
    
    func urlString() -> String {
        return BaseConstant.baseUrl + self.path()
    }
    
    struct BaseConstant {
        static let baseUrl = "https://shoe121231.000webhostapp.com/api"
    }
    
    
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "Invalid Encoding", code: 0, userInfo: nil)
        }
        return dictionary
    }
}
