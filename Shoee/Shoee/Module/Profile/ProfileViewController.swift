import UIKit

class ProfileViewController: UIViewController {
    
    lazy var popUpLoading = PopUpLoading(on: view)
    
    @IBAction func btnEditProfile(_ sender: Any) {
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func yourorders(_ sender: Any) {
        let vc = PaymentProcessViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func help(_ sender: Any) {
        let vc = HomeSoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        
        popUpLoading.showInFull()
        
        APIManager.shared.makeAPICall(endpoint: .logout(vc: self)) {
            (result: Result<ResponseLogoutModel, Error>) in
            switch result {
            case .success(let responseLogout):
                print("Logout success: \(responseLogout)")
                
                TokenService.shared.deleteToken()
                self.popUpLoading.dismissImmediately()
                
                let loginViewController = LoginViewController()
                let navigationController = UINavigationController(rootViewController: loginViewController)
                UIApplication.shared.keyWindow?.rootViewController = navigationController
                
            case .failure(let error):
                self.popUpLoading.dismissImmediately()
                self.showCustomAlertWith(
                    detailResponseOkAction: nil,
                    title: "Error",
                    message: error.localizedDescription,
                    image: #imageLiteral(resourceName: "ic_error"),
                    actions: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpLoading.dismissImmediately()
        // Additional setup if needed
    }
}
