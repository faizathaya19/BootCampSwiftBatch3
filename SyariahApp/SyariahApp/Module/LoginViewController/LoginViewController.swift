import UIKit

// Enum for error messages and titles
enum LoginError: String {
    case emptyEmail = "Please fill in the email field."
    case emptyPassword = "Please fill in the password field."
    case invalidCredentials = "Invalid email or password."
}

struct User {
    let email: String
    let password: String
}

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleTopLogin: UILabel!
    @IBOutlet weak var imageTopLogin: UIImageView!
    @IBOutlet weak var viewLogin: FormView!
    @IBOutlet weak var emailField: ReusableTextField!
    @IBOutlet weak var passwordField: ReusableTextField!

    // MARK: - Actions
    @IBAction func logInButton(_ sender: Any) {
        guard let email = emailField.formTextfield.text, !email.isEmpty else {
            showErrorDialog(message: LoginError.emptyEmail.rawValue, title: "Error")
            return
        }

        guard let password = passwordField.formTextfield.text, !password.isEmpty else {
            showErrorDialog(message: LoginError.emptyPassword.rawValue, title: "Error")
            return
        }

        if validateCredentials(email: email, password: password) {
            navigateToMainTabBar()
        } else {
            showErrorDialog(message: LoginError.invalidCredentials.rawValue, title: "Error")
        }
    }

    @IBAction func signUpButton(_ sender: Any) {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        configureNavigationBar()
        animateViews()
    }

    // MARK: - Private Properties
    private lazy var errorDialog: ReusableDialogShowViewController = {
        let dialog = ReusableDialogShowViewController()
        return dialog
    }()

    // MARK: - Private Methods
    private func setupTextFields() {
        emailField.setup(title: "Email")
        passwordField.setup(title: "Password")
        passwordField.formTextfield.isSecureTextEntry = true
    }

    private func configureNavigationBar() {
        hidesBottomBarWhenPushed = false
        navigationController?.isNavigationBarHidden = true
    }

    private func validateCredentials(email: String, password: String) -> Bool {
        let defaultUser = User(email: "123", password: "123")
        return email == defaultUser.email && password == defaultUser.password
    }

    private func navigateToMainTabBar() {
        let mainTabBarVC = MainTabBarViewController()
        navigationController?.pushViewController(mainTabBarVC, animated: true)
    }

    private func showErrorDialog(message: String, title: String) {
        let dialogData = DialogData(title: title, message: message)
        errorDialog.showError(dialogData: dialogData)
        errorDialog.appear(sender: self)
    }

    private func animateViews() {
        viewLogin.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        titleTopLogin.alpha = 0
        imageTopLogin.alpha = 0

        UIView.animate(withDuration: Constants.animationDuration, delay: Constants.animationDelay, options: .curveEaseInOut, animations: {
            self.viewLogin.transform = .identity
            self.titleTopLogin.alpha = 1
            self.imageTopLogin.alpha = 1
        })
    }
}

// Constants
private extension LoginViewController {
    enum Constants {
        static let animationDuration: TimeInterval = 0.5
        static let animationDelay: TimeInterval = 0.2
    }
}
