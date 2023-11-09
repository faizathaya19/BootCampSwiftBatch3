//
//  WebService.swift
//  Shoee
//
//  Created by Phincon on 09/11/23.
//

import Foundation

enum AuthenticationError: Error{
    case invalidCredentials
    case custom(errorMessage: String)
}

struct LoginRequestBody: Codable{
    let email: String
    let password: String
}

struct LoginResponse: Codable{
    let token: String?
    let message: String?
    let success: Bool?
}

class WebService {
    
    func login(email: String, password: String, completion: @escaping (Result<String,AuthenticationError>) -> Void){
        
        guard let url = URL(string: "https://9c0046df-840b-45c3-b9d6-ee8726fb92b4.mock.pstmn.io/api/login") else {
            completion(.failure(.custom(errorMessage: "URL salah")))
            return
        }
        
        let body = LoginRequestBody(email: email, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("", forHTTPHeaderField: "")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "ga ada data")))
                return
            }
            
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            guard let token = loginResponse.token else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            completion(.success(token))
            
        }.resume()
        
    }
}
