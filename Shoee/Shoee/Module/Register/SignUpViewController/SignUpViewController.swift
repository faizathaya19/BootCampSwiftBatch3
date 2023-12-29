import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var phoneNumber: CustomTextField!
    @IBOutlet weak var fullnameTextFieldCustom: CustomTextField!
    @IBOutlet weak var usernameTextFieldCustom: CustomTextField!
    @IBOutlet weak var emailTextFieldCustom: CustomTextField!
    @IBOutlet weak var passwordTextFieldCustom: CustomTextField!
    
    private var viewModel: SignUpViewModel!
    lazy var popUpLoading = PopUpLoading(on: view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    private func setupUI() {
        setupTextFields()
        navigationController?.isNavigationBarHidden = true
        popUpLoading.dismissImmediately()
    }
    
    private func setupViewModel() {
        viewModel = SignUpViewModel()
        viewModel.delegate = self
        viewModel.popUpLoading = popUpLoading
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        guard let name = fullnameTextFieldCustom.inputTextField.text, !name.isEmpty else {
            handleError(message: "Please enter your full name")
            return
        }
        
        guard let username = usernameTextFieldCustom.inputTextField.text, !username.isEmpty else {
            handleError(message: "Please enter a username")
            return
        }
        
        
        
        guard let email = emailTextFieldCustom.inputTextField.text, !email.isEmpty else {
            handleError(message: "Please enter your email address")
            return
        }
        
        if !isValidEmail(email) {
            handleError(message: "Please enter a valid email address")
            return
        }
        
        guard let password = passwordTextFieldCustom.inputTextField.text, !password.isEmpty else {
            handleError(message: "Please enter a password")
            return
        }
        
        if !isValidPasswordLength(password) {
            handleError(message: "Password must be between 8 and 15 characters")
            return
        }
        
        guard let number = phoneNumber.inputTextField.text, !number.isEmpty else {
            handleError(message: "Please enter your phone number")
            return
        }
        
        let registerParams = RegisterParam(name: name, username: username, email: email, password: password, phone: number)
        viewModel.performRegistration(with: registerParams)
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        viewModel.navigateToLogin()
    }
    
    private func setupTextFields() {
        fullnameTextFieldCustom.configure(title: "Full Name", image: UIImage(named: "ic_fullname"), placeholder: "Your Full Name")
        phoneNumber.configure(title: "Phone Number", image: UIImage(named: "ic_phone"), placeholder: "Your Phone Number", validationType: .phoneNumber)
        usernameTextFieldCustom.configure(title: "Username", image: UIImage(named: "ic_username"), placeholder: "Your Username")
        emailTextFieldCustom.configure(title: "Email", image: UIImage(named: "ic_email"), placeholder: "Your Email Address")
        passwordTextFieldCustom.configure(title: "Password", image: UIImage(named: "ic_password"), placeholder: "Your Password", isPasswordField: true)
        passwordTextFieldCustom.inputTextField.isSecureTextEntry = true
    }
    
    private func handleError(message: String) {
        showCustomAlertWith(
            detailResponseOkAction: nil,
            title: "Error",
            message: message,
            image: #imageLiteral(resourceName: "ic_error"),
            actions: nil
        )
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPasswordLength(_ password: String) -> Bool {
        return (8...15).contains(password.count)
    }
}



