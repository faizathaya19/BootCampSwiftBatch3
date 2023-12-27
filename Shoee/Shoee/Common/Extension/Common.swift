import Foundation
import UIKit

class Common {
    
    static let shared = Common()

    func addViewToWindow(window: (UIWindow) -> Void) {
        let currentWindow = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        if let activeWindow = currentWindow {
            window(activeWindow)
        }
    }

}
