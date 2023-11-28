import Foundation
import Alamofire

enum EndPoint {
    case register(RegisterParam)
    case login(LoginParam)
    case logout(vc: UIViewController)
    case categories
    case products(id: Int?, limit: Int?, name: String?, description: String?, priceFrom: Int?, priceTo: Int?, tags: String?, categories: Int?)
    case user
    
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
            
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .register, .login, .logout:
            return .post
        case .categories, .products, .user:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .register(let params):
            return try? params.asDictionary()
        case .login(let params):
            return try? params.asDictionary()
        case .products(let id, let limit, let name, let description, let priceFrom, let priceTo, let tags, let categories):
            var params: [String: Any] = [:]
            
            if let id = id { params["id"] = id }
            if let limit = limit { params["limit"] = limit }
            if let name = name { params["name"] = name }
            if let description = description { params["description"] = description }
            if let priceFrom = priceFrom { params["price_from"] = priceFrom }
            if let priceTo = priceTo { params["price_to"] = priceTo }
            if let tags = tags { params["tags"] = tags }
            if let categories = categories { params["categories"] = categories }
            
            return params
        default:
            return nil
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .register:
            return ["Accept": "application/json"]
        case .logout, .user:
            return ["Accept": "application/json", "Authorization": "Bearer \(TokenService.shared.retrieveToken())"]
        default:
            return nil
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch self {
        case .register, .login, .categories, .products, .user:
            return URLEncoding.queryString
        default: return JSONEncoding.default
        }
    }
    
    func urlString() -> String {
        return BaseConstant.baseUrl + self.path()
    }
    
    struct BaseConstant {
        static let baseUrl = "https://shoesez.000webhostapp.com/api"
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
