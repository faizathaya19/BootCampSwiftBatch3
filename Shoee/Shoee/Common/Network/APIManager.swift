//import Foundation
//import Alamofire
//
//let base_url = "https://shoesez.000webhostapp.com/api"
//let register_url = "\(base_url)/register"
//let login_url = "\(base_url)/login"
//let logout_url = "\(base_url)/logout"
//
//enum APIError: Error{
//    case custom(message: String)
//}
//
//typealias Handler = (Swift.Result<Any?, APIError>) -> Void
//
//class APIManager{
//    static let shareInstance = APIManager()
//    
//    func callinRegisterAPI(register: RegisterModel, completionHandler: @escaping (Bool, String) -> ()){
//        let headers: HTTPHeaders = [
//            .accept("application/json")
//        ]
//        
//        AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
//            debugPrint(response)
//            switch response.result{
//            case . success(let data):
//                do{
//                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
//                    if response.response?.statusCode == 200{
//                        completionHandler(true, "User registered successfully")
//                    }else{
//                        completionHandler(false, "Registration failed. Please try again.")
//                    }
//                }catch{
//                    print(error.localizedDescription)
//                    completionHandler(false, "Please try again.")
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//                completionHandler(false, "Please try again.")
//            }
//        }
//    }
//    
//    func callingLoginAPI(login: LoginModel, completionHandler: @escaping Handler){
//        
//        AF.request(login_url, method: .post, parameters: login, encoder: JSONParameterEncoder.default).response{ response in
//            debugPrint(response)
//            switch response.result{
//            case .success(let data):
//                do{
//                    let json = try JSONDecoder().decode(ResponseModel.self, from: data!)
//                    
//                    //                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
//                    if response.response?.statusCode == 200{
//                        completionHandler(.success(json))
//                    }else{
//                        completionHandler(.failure(.custom(message: "Please check your network connectifity")))
//                    }
//                }catch{
//                    print(error.localizedDescription)
//                    completionHandler(.failure(.custom(message: "Please try again.")))
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//                completionHandler(.failure(.custom(message: "Please try again.")))
//            }
//        }
//    }
//    
//    func callingLogoutAPI(vc: UIViewController, completion: @escaping (Bool) -> Void) {
//        let headers: HTTPHeaders = [
//            "accept": "application/json",
//            "Authorization": "Bearer \(TokenService.shared.getToken())"
//        ]
//
//        AF.request(logout_url, method: .post, headers: headers).response { response in
//            switch response.result {
//            case .success:
//                TokenService.shared.removeToken()
//                completion(true)
//            case .failure(let error):
//                print("API Error: \(error.localizedDescription)")
//                completion(false)
//            }
//        }
//    }
//
//
//}

//
//import Foundation
//import Alamofire
//
//struct User: Codable {
//    var id: Int
//    var name: String
//    var email: String
//    var username: String
//    var roles: String
//    var phone: String?
//    var profilePhotoURL: String?
//}
//
//struct ProductCategory: Codable {
//    var id: Int
//    var name: String
//}
//
//struct ProductCategoriesResponse: Codable {
//    var meta: Meta
//    var data: ProductCategoriesData
//}
//
//struct Meta: Codable {
//    var code: Int
//    var status: String
//    var message: String
//}
//
//struct ProductCategoriesData: Codable {
//    var data: [ProductCategory]
//}
//
//class APIManager {
//
//    static let shareInstance = APIManager()
//
//    private init() {}
//
//    // MARK: - Login
//    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
//        let url = "https://shoesez.000webhostapp.com/api/login"
//        let parameters: [String: Any] = ["email": email, "password": password]
//
//        AF.request(url, method: .post, parameters: parameters)
//            .responseDecodable(of: User.self) { response in
//                switch response.result {
//                case .success(let user):
//                    completion(.success(user))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//
//    // MARK: - Register
//    func register(name: String, email: String, password: String, username: String, completion: @escaping (Result<User, Error>) -> Void) {
//        let url = "https://shoesez.000webhostapp.com/api/register"
//        let parameters: [String: Any] = ["name": name, "email": email, "password": password, "username": username]
//
//        AF.request(url, method: .post, parameters: parameters, headers: ["Accept": "application/json"])
//            .responseDecodable(of: User.self) { response in
//                switch response.result {
//                case .success(let user):
//                    completion(.success(user))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//
//    // MARK: - Logout
//    func logout(vc: UIViewController, completion: @escaping (Bool) -> Void) {
//        let url = "https://shoesez.000webhostapp.com/api/logout"
//        let headers: HTTPHeaders = [
//            "Accept": "application/json",
//            "Authorization": "Bearer \(TokenService.shared.getToken())"
//        ]
//
//        AF.request(url, method: .post, headers: headers)
//            .response { response in
//                switch response.result {
//                case .success:
//                    TokenService.shared.removeToken()
//                    completion(true)
//                case .failure(let error):
//                    print("API Error: \(error.localizedDescription)")
//                    completion(false)
//                }
//            }
//    }
//    
//    // MARK: - Get User
//    func getUser(token: String, completion: @escaping (Result<User, Error>) -> Void) {
//        let url = "https://shoesez.000webhostapp.com/api/user"
//        let headers: HTTPHeaders = ["Accept": "application/json", "Authorization": "Bearer \(token)"]
//
//        AF.request(url, method: .get, headers: headers)
//            .responseDecodable(of: User.self) { response in
//                switch response.result {
//                case .success(let user):
//                    completion(.success(user))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//
//    // MARK: - Get Product Categories
//    func getProductCategories(completion: @escaping (Result<[ProductCategory], Error>) -> Void) {
//        let url = "https://shoesez.000webhostapp.com/api/categories"
//
//        AF.request(url, method: .get, headers: ["Accept": "application/json"])
//            .responseDecodable(of: ProductCategoriesResponse.self) { response in
//                switch response.result {
//                case .success(let categoriesResponse):
//                    completion(.success(categoriesResponse.data.data))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//}

// CustomAPIManager.swift
// Manajer kustom untuk pemanggilan API dengan menggunakan Alamofire

import Foundation
import Alamofire

class APIManager: NSObject {
    // Singleton instance
    static let shared = APIManager()
    
    // Dependency Injection
    override init() {}
    
    // Membuat pemanggilan API generik
    func makeAPICall<T: Codable>(endpoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
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

