import Foundation
import Alamofire

enum EndPoint {
    case register(RegisterParam)
    case login(LoginParam)
    case logout(vc: UIViewController)
    case categories

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
        }
    }

    func method() -> HTTPMethod {
        switch self {
        case .register, .login, .logout:
            return .post
        case .categories:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .register(let params):
            return try? params.asDictionary()
        case .login(let params):
            return try? params.asDictionary()
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        switch self {
        case .register:
            return ["Accept": "application/json"]
        case .logout:
            return ["Accept": "application/json", "Authorization": "Bearer \(TokenService.shared.getToken())"]
        default:
            return nil
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch self {
        case .register, .login, .categories:
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
