import UIKit

extension LoginViewController: LoginViewModelDelegate {
    func didLoginSuccessfully() {
        DispatchQueue.main.async {
            self.signInButton.hideSkeleton()
            let vc = CustomMainTabBar()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didFailLogin(with error: Error) {
        DispatchQueue.main.async {
            self.signInButton.hideSkeleton()
            self.showCustomAlertWith(
                detailResponseOkAction: nil,
                title: "Error",
                message: error.localizedDescription,
                image: #imageLiteral(resourceName: "ic_error"),
                actions: nil
            )
        }
    }
    
    func navigateToSignUp() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
