import Foundation
import Alamofire

class APIManagerPaymentGateWay: NSObject {
    // Singleton instance
    static let shared = APIManagerPaymentGateWay()
    
    // Dependency Injection
    override init() {}
    
    // Membuat pemanggilan API generik
    func makeAPICall<T: Codable>(endpoint: PaymentGateWayEndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        // Mendapatkan header dari endpoint
        var headers: HTTPHeaders = [:]
        
        if let endpointHeaders = endpoint.headers {
            headers = HTTPHeaders(endpointHeaders)
        }
        
        // Menambahkan API key ke dalam header
        
        AF.request(endpoint.urlString(),
                   method: endpoint.method(),
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: headers)
        .validate()
        .responseDecodable(of: T.self) { (response) in
            // Menangani hasil pemanggilan API
            guard let item = response.value else {
                completion(.failure(response.error!))
                return
            }
            completion(.success(item))
        }
    }
    
    
}

