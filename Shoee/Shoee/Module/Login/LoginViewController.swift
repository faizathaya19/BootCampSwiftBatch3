import UIKit

class LoginViewController: UIViewController, CustomTextFieldDelegate {
    
    @IBOutlet weak var emailTextFieldCustom: CustomTextField!
    @IBOutlet weak var passwordTextFieldCustom: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        guard let email = emailTextFieldCustom.inputTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email address")
            return
        }
        
        guard let password = passwordTextFieldCustom.inputTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter a password")
            return
        }
        
        let modelLogin = LoginModel(email: email, password: password)
        
        APIManager.shareInstance.callingLoginAPI(login: modelLogin) { [weak self] (result) in
            switch result {
            case .success(let json):
                guard let responseModel = json as? ResponseModel else {
                    print("Error: Invalid response structure")
                    return
                }

                let accessToken = responseModel.data.accessToken
                let user = responseModel.data.user

                let name = user.name
                let email = user.email
                let username = user.username
                let profilePhotoURL = user.profilePhotoURL

                TokenService.shared.saveToken(accessToken)

                DispatchQueue.main.async {
                    let vc = CustomMainTabBar()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                //                let name = (json as AnyObject).value(forKey: "name") as! String
                //                let email = (json as AnyObject).value(forKey: "email") as! String
                //                let username = (json as AnyObject).value(forKey: "username") as! String
                //                let phone = (json as AnyObject).value(forKey: "phone") as! String
                //                let profile_photo_url = (json as AnyObject).value(forKey: "profile_photo_url") as! String
                //                let modelLoginResponse = LoginResponseModel(name: name, email: email, username: username, phone: phone, profile_photo_url: profile_photo_url)
                //                print(modelLoginResponse)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTextFields() {
        emailTextFieldCustom.delegate = self
        emailTextFieldCustom.configure(title: "Email", image: UIImage(named: "ic_email"), placeholder: "Your Email Address")
        
        passwordTextFieldCustom.delegate = self
        passwordTextFieldCustom.configure(title: "Password", image: UIImage(named: "ic_password"), placeholder: "Your Password")
    }
    
    // Implement the CustomTextFieldDelegate method if needed
    func customTextFieldDidEndEditing(_ textField: CustomTextField) {
        // Handle any additional logic when a text field ends editing if needed
    }
}

extension LoginViewController{
    static func shareInstance() -> LoginViewController{
        return LoginViewController()
    }
}
