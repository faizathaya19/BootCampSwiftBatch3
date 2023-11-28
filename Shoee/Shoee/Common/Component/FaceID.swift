import Foundation
import LocalAuthentication

class FaceID {
    
    let context = LAContext()
    
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authentication required to access your data"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                if success {
                    print("FaceID authentication successful")
                    completion(true)
                } else {
                    if let error = evaluateError {
                        print("FaceID authentication error: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            print("FaceID authentication not available")
            completion(false)
        }
    }
    
}
