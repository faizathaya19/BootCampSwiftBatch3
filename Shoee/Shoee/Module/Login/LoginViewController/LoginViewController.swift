import UIKit
import SkeletonView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextFieldCustom: CustomTextField!
    @IBOutlet weak var passwordTextFieldCustom: CustomTextField!
    @IBOutlet weak var signInButton: UIButton!
    
    private var viewModel: LoginViewModel!
    lazy var popUpLoading = PopUpLoading(on: view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    private func setupUI() {
        setupTextFields()
        popUpLoading.dismissImmediately()
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupViewModel() {
        viewModel = LoginViewModel()
        viewModel.delegate = self
        viewModel.popUpLoading = popUpLoading
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        signInButton.showAnimatedGradientSkeleton(usingGradient: Constants.skeletonColor)
        
        guard let email = emailTextFieldCustom.inputTextField.text, !email.isEmpty else {
            handleError(message: "Please enter your email address")
            return
        }
        
        guard let password = passwordTextFieldCustom.inputTextField.text, !password.isEmpty else {
            handleError(message: "Please enter a password")
            return
        }
        
        let loginParams = LoginParam(email: email, password: password)
        viewModel.performLogin(with: loginParams)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        viewModel.navigateToSignUp()
    }
    
    private func setupTextFields() {
        emailTextFieldCustom.configure(title: "Email", image: UIImage(named: "ic_email"), placeholder: "Your Email Address")
        passwordTextFieldCustom.configure(title: "Password", image: UIImage(named: "ic_password"), placeholder: "Your Password", isPasswordField: true)
        passwordTextFieldCustom.inputTextField.isSecureTextEntry = true
    }
    
    private func handleError(message: String) {
        signInButton.hideSkeleton()
        showCustomAlertWith(
            detailResponseOkAction: nil,
            title: "Error",
            message: message,
            image: #imageLiteral(resourceName: "ic_error"),
            actions: nil
        )
    }
}
