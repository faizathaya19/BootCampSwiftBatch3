import UIKit

class ProfileViewController: UIViewController {
    
    @IBAction func btnEditProfile(_ sender: Any) {
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func btnLogout(_ sender: Any) {
        APIManager.shared.makeAPICall(endpoint: .logout(vc: self)) { (result: Result<ResponseLogoutModel, Error>) in
            switch result {
            case .success(let responseLogout):
                print("Logout success: \(responseLogout)")
           
                TokenService.shared.removeToken()
                
                let loginViewController = LoginViewController()
                let navigationController = UINavigationController(rootViewController: loginViewController)
                UIApplication.shared.keyWindow?.rootViewController = navigationController
                
            case .failure(let error):
                // Handle logout failure, display an error message, etc.
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
        
        
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
        //        APIManager.shareInstance.callingLogoutAPI(vc: self) { success in
        //            if success {
        //                // Successfully logged out, navigate to the login screen
        //                let loginViewController = LoginViewController()
        //                let navigationController = UINavigationController(rootViewController: loginViewController)
        //                UIApplication.shared.keyWindow?.rootViewController = navigationController
        //            }
        //        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup if needed
    }
}
