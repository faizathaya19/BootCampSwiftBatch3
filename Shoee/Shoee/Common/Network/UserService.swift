import Foundation
import Alamofire

class UserService {
    
    static let shared = UserService()
    
    private init() {}

    var userList: [User] = []

    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        APIManager.shared.makeAPICall(endpoint: .user) { (result: Result<ResponseUserModel, Error>) in
            switch result {
            case .success(let response):
                self.userList = [response.data]
                completion(.success([response.data]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
