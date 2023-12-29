import UIKit

extension SignUpViewController: SignUpViewModelDelegate {
    func didRegisterSuccessfully() {
        DispatchQueue.main.async {
            let mainTabBarVC = CustomMainTabBar()
            self.navigationController?.pushViewController(mainTabBarVC, animated: true)
        }
    }

    func didFailRegistration(with error: Error) {
        DispatchQueue.main.async {
            self.showCustomAlertWith(
                detailResponseOkAction: nil,
                title: "Error",
                message: "Error Server",
                image: #imageLiteral(resourceName: "ic_error"),
                actions: nil
            )
        }
        
    }
    
    func navigateToLogin() {
        navigationController?.popViewController(animated: true)
    }
}
