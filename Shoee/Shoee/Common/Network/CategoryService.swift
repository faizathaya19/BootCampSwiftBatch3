import Foundation
import Alamofire

class CategoryService {

    static let shared = CategoryService()
    
    var categoryList: [CategoryModel] = []

    func getCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        APIManager.shared.makeAPICall(endpoint: .categories) { (result: Result<ResponseCategoryModel, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data.data.reversed()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
