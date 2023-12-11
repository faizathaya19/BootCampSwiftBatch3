import Foundation

// Contoh kelas untuk manajemen User Defaults
class UserDefaultManager {
    
    // Fungsi untuk menyimpan ID pengguna
    static func saveUserID(_ userID: Int) {
        UserDefaults.standard.set(userID, forKey: "userID")
    }
    
    // Fungsi untuk mengambil ID pengguna
    static func getUserID() -> Int? {
        return UserDefaults.standard.integer(forKey: "userID")
    }
    
    // Fungsi untuk menghapus ID pengguna
    static func deleteUserID() {
        UserDefaults.standard.removeObject(forKey: "userID")
    }
    
    // Fungsi untuk memeriksa keberadaan ID pengguna
    static func hasUserID() -> Bool {
        return UserDefaults.standard.string(forKey: "userID") != nil
    }
}
