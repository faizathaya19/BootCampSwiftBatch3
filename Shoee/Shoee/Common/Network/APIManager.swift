import Foundation
import Alamofire

class APIManager: NSObject {
    
    static let shared = APIManager()
    
    override init() {}
    
    func makeAPICall<T: Codable>(endpoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        
        var headers: HTTPHeaders = [:]
        
        if let endpointHeaders = endpoint.headers {
            headers = HTTPHeaders(endpointHeaders)
        }
        
        AF.request(endpoint.urlString(),
                   method: endpoint.method(),
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: headers)
        .validate()
        .responseDecodable(of: T.self) { (response) in
          
            guard let item = response.value else {
                completion(.failure(response.error!))
                return
            }
            completion(.success(item))
        }
    }
    
    
}

