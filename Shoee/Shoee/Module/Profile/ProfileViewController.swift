import UIKit

class ProfileViewController: UIViewController {

    @IBAction func btnEditProfile(_ sender: Any) {
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        APIManager.shareInstance.callingLogoutAPI(vc: self) { success in
            if success {
                // Successfully logged out, navigate to the login screen
                let loginViewController = LoginViewController()
                let navigationController = UINavigationController(rootViewController: loginViewController)
                UIApplication.shared.keyWindow?.rootViewController = navigationController
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
