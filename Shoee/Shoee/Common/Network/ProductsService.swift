import Foundation
import Alamofire

class ProductsService {

    static let shared = ProductsService()
    
    var productsList: [ProductModel] = []

    private init() {}

    func getProducts(id: Int? = nil, limit: Int? = nil, name: String? = nil, description: String? = nil, priceFrom: Int? = nil, priceTo: Int? = nil, tags: String? = nil, categories: Int? = nil, completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        APIManager.shared.makeAPICall(endpoint: .products(id: id, limit: limit, name: name, description: description, priceFrom: priceFrom, priceTo: priceTo, tags: tags, categories: categories)) { (result: Result<ResponseProductModel, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
