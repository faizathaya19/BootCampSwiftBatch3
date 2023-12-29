import Foundation

class UserDefaultManager {
    
    static func saveUserID(_ userID: Int) {
        UserDefaults.standard.set(userID, forKey: "userID")
    }
    
    static func getUserID() -> Int? {
        return UserDefaults.standard.integer(forKey: "userID")
    }
    
    static func deleteUserID() {
        UserDefaults.standard.removeObject(forKey: "userID")
    }
    
    static func hasUserID() -> Bool {
        return UserDefaults.standard.string(forKey: "userID") != nil
    }
}
