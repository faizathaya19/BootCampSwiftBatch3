//
//  APIHandler.swift
//  PhoneBook
//
//  Created by Phincon on 07/11/23.
//

import Foundation
import Alamofire

struct Model:Codable{
    let id: Int
    let first_name: String
    let last_name: String
    let phone_number: String
}

class APIHandler{
    static let shareInstance = APIHandler()
    
    func fetchingAPIData(handler: @escaping (_ apiData:[Model])->(Void)){
        let url = "https://deploy-phonebook-production.up.railway.app/api/"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { responce in
            switch responce.result {
            case .success(let data):
                do {
                    let jsondata = try JSONDecoder().decode([Model].self, from: data!)
                    print(jsondata)
                    handler(jsondata)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
