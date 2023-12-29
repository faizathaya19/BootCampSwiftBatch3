import Foundation
import UIKit

extension UITextField {
    
    func validatePhoneNumberInput(in range: NSRange, replacementString string: String, maxLength: Int) -> Bool {
        let newLength = (text ?? "").count + string.count - range.length
        return newLength <= maxLength && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
