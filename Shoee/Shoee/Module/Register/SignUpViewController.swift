import UIKit

class SignUpViewController: UIViewController, CustomTextFieldDelegate {
    
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
        
        let modelRegister = RegisterModel(name: name, username: username, email: email, password: password)
        
        APIManager.shareInstance.callinRegisterAPI(register: modelRegister) { (isSuccess, str) in
            DispatchQueue.main.async {
                if isSuccess {
                    self.showAlert(title: "Success", message: str)
                } else {
                    self.showAlert(title: "Error", message: str)
                }
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
        fullnameTextFieldCustom.delegate = self
        fullnameTextFieldCustom.configure(title: "Full Name", image: UIImage(named: "ic_fullname"), placeholder: "Your Full Name")
        
        usernameTextFieldCustom.delegate = self
        usernameTextFieldCustom.configure(title: "Username", image: UIImage(named: "ic_username"), placeholder: "Your Username")
        
        emailTextFieldCustom.delegate = self
        emailTextFieldCustom.configure(title: "Email", image: UIImage(named: "ic_email"), placeholder: "Your Email Address")
        
        passwordTextFieldCustom.delegate = self
        passwordTextFieldCustom.configure(title: "Password", image: UIImage(named: "ic_password"), placeholder: "Your Password")
    }
    
    // Implement the CustomTextFieldDelegate method
    func customTextFieldDidEndEditing(_ textField: CustomTextField) {
        // Handle any additional logic when a text field ends editing if needed
    }
}
