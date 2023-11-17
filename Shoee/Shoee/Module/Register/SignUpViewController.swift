import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullnameTextFieldCustom: CustomTextField!
    @IBOutlet weak var usernameTextFieldCustom: CustomTextField!
    @IBOutlet weak var emailTextFieldCustom: CustomTextField!
    @IBOutlet weak var passwordTextFieldCustom: CustomTextField!
    
    @IBAction func btnSignUp(_ sender: Any) {
        guard let name = fullnameTextFieldCustom.inputTextField.text, !name.isEmpty else {
            showAlert(title: "Error", message: "Please enter your full name")
            return
        }

        guard let username = usernameTextFieldCustom.inputTextField.text, !username.isEmpty else {
            showAlert(title: "Error", message: "Please enter a username")
            return
        }

        guard let email = emailTextFieldCustom.inputTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email address")
            return
        }

        guard let password = passwordTextFieldCustom.inputTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter a password")
            return
        }

        let registerParams = RegisterParam(name: name, username: username, email: email, password: password)

        APIManager.shared.makeAPICall(endpoint: .register(registerParams)) { (result: Result<ResponseRegisterModel, Error>) in
            switch result {
            case .success(let responseRegister):
                print("Registration success: \(responseRegister)")
                
                guard let responseRegister = responseRegister as? ResponseRegisterModel else {
                    print("Error: Invalid response structure")
                    return
                }
                
                let accessToken = responseRegister.data.accessToken
                TokenService.shared.saveToken(accessToken)
 

                DispatchQueue.main.async {
                    let mainTabBarVC = CustomMainTabBar()
                    self.navigationController?.pushViewController(mainTabBarVC, animated: true)
                }

            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    

    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupTextFields() {
        fullnameTextFieldCustom.configure(title: "Full Name", image: UIImage(named: "ic_fullname"), placeholder: "Your Full Name")
        
        usernameTextFieldCustom.configure(title: "Username", image: UIImage(named: "ic_username"), placeholder: "Your Username")
        
        emailTextFieldCustom.configure(title: "Email", image: UIImage(named: "ic_email"), placeholder: "Your Email Address")
        
        passwordTextFieldCustom.configure(title: "Password", image: UIImage(named: "ic_password"), placeholder: "Your Password")
    }
    
}
