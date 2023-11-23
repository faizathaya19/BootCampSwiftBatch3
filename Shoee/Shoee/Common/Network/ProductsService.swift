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

    // Method to fetch product details based on product ID
    func getProductDetails(productID: Int, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        // Call your API or database to fetch product details based on productID
        // Replace the following placeholder with your actual implementation

        // Example: Assuming productsList contains all products, find the one with the matching ID
        if let product = productsList.first(where: { $0.id == productID }) {
            completion(.success(product))
        } else {
            // Replace this with your actual error handling
            let error = NSError(domain: "YourAppDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])
            completion(.failure(error))
        }
    }
}
