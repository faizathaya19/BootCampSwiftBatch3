import Foundation
import Alamofire

let base_url = "https://shoesez.000webhostapp.com/api"
let register_url = "\(base_url)/register"
let login_url = "\(base_url)/login"
let logout_url = "\(base_url)/logout"

enum APIError: Error{
    case custom(message: String)
}

typealias Handler = (Swift.Result<Any?, APIError>) -> Void

class APIManager{
    static let shareInstance = APIManager()
    
    func callinRegisterAPI(register: RegisterModel, completionHandler: @escaping (Bool, String) -> ()){
        let headers: HTTPHeaders = [
            .accept("application/json")
        ]
        
        AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            debugPrint(response)
            switch response.result{
            case . success(let data):
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
                    if response.response?.statusCode == 200{
                        completionHandler(true, "User registered successfully")
                    }else{
                        completionHandler(false, "Registration failed. Please try again.")
                    }
                }catch{
                    print(error.localizedDescription)
                    completionHandler(false, "Please try again.")
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(false, "Please try again.")
            }
        }
    }
    
    func callingLoginAPI(login: LoginModel, completionHandler: @escaping Handler){
        
        AF.request(login_url, method: .post, parameters: login, encoder: JSONParameterEncoder.default).response{ response in
            debugPrint(response)
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSONDecoder().decode(ResponseModel.self, from: data!)
                    
                    //                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
                    if response.response?.statusCode == 200{
                        completionHandler(.success(json))
                    }else{
                        completionHandler(.failure(.custom(message: "Please check your network connectifity")))
                    }
                }catch{
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Please try again.")))
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(.failure(.custom(message: "Please try again.")))
            }
        }
    }
    
    func callingLogoutAPI(vc: UIViewController, completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(TokenService.shared.getToken())"
        ]

        AF.request(logout_url, method: .post, headers: headers).response { response in
            switch response.result {
            case .success:
                TokenService.shared.removeToken()
                completion(true)
            case .failure(let error):
                print("API Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }


}
