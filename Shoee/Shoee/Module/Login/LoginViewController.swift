import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextFieldCustom: CustomTextField!
    @IBOutlet weak var passwordTextFieldCustom: CustomTextField!
    
    // Create an instance of LoginViewModel
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        let vc = CustomMainTabBar()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTextFields() {
        emailTextFieldCustom.setup(title: "Email", image: UIImage(named: "ic_email"), placeHolder: "Your Email Address")
        passwordTextFieldCustom.setup(title: "Password", image: UIImage(named: "ic_password"), placeHolder: "Your Password")
    }
}
