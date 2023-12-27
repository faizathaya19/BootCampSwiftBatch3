import Foundation
import UIKit
import SkeletonView

class Constants {
    
    static let skeletonColor = SkeletonGradient(baseColor: UIColor.midnightBlue)
    
    static let defaultImageURL = "https://static.vecteezy.com/system/resources/thumbnails/007/872/974/small/file-not-found-illustration-with-confused-people-holding-big-magnifier-search-no-result-data-not-found-concept-can-be-used-for-website-landing-page-animation-etc-vector.jpg"
    
    static let defaultCategoryId = 6
    
    static let midtransKey: String = loadValueFromPlist(forKey: "Midtrans-Key")
    
    static let midtransUrl: String = loadValueFromPlist(forKey: "Midtrans-Url")
    
    static let apiUrl: String = loadValueFromPlist(forKey: "Api-Url")
    
    static func loadValueFromPlist(forKey key: String) -> String {
        guard let path = Bundle.main.path(forResource: "Key", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let value = dict[key] as? String else {
            fatalError("\(key) not found in Key.plist")
        }
        return value
    }
    
    
    
    
    static let primary = UIColor(named: "Primary")
    static let primaryText = UIColor(named: "PrimaryText")
    static let secondaryText = UIColor(named: "SecondaryText")
    static let secondary = UIColor(named: "Secondary")
    static let bG4 = UIColor(named: "BG4")
    
    static let formatDate = "yyyy-MM-dd HH:mm:ss"
    static let paymentSuccessLottie = "payment_success_lottie"
}


