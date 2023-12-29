import UIKit

extension LoginViewController: LoginViewModelDelegate {
    func didLoginSuccessfully() {
        DispatchQueue.main.async {
            self.signInButton.hideSkeleton()

            let vc = CustomMainTabBar()

            if let navigationController = self.navigationController {
                navigationController.setViewControllers([vc], animated: true)
            }
        }
    }
    
    func didFailLogin(with error: Error) {
        DispatchQueue.main.async {
            self.signInButton.hideSkeleton()
            self.showCustomAlertWith(
                detailResponseOkAction: nil,
                title: "Error",
                message: "Error Server",
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
