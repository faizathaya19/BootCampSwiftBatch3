import UIKit

extension LoginViewController: LoginViewModelDelegate {
    func didLoginSuccessfully() {
        DispatchQueue.main.async {
            self.signInButton.hideSkeleton()

            // Create the new view controller
            let vc = CustomMainTabBar()

            // Set the new view controller as the only item in the navigation stack
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
                message: "\(error)",
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
