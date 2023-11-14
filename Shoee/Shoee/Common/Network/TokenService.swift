import Foundation

struct TokenKey{
    static let userLogin = "access_token"
}

class TokenService {
    static let shared = TokenService()
    private let userDefaults = UserDefaults.standard
    
    func saveToken(_ token: String) {
        userDefaults.set(token, forKey: TokenKey.userLogin)
        userDefaults.synchronize()
    }
    
    func getToken() -> String {
        return userDefaults.string(forKey: TokenKey.userLogin) ?? ""
    }
    
    func checkForLogin() -> Bool {
        return !getToken().isEmpty
    }
    
    func removeToken() {
        userDefaults.removeObject(forKey: TokenKey.userLogin)
        userDefaults.synchronize() 
    }
}
