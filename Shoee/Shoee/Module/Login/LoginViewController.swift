import UIKit

class LoginViewController: UIViewController {
    
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
        
        let loginParams = LoginParam(email: email, password: password)
        
        APIManager.shared.makeAPICall(endpoint: .login(loginParams)) { (result: Result<ResponseLoginModel, Error>) in
            switch result {
            case .success(let responseLoginModel):
                print("Login success: \(responseLoginModel)")
                
                guard let responseLoginModel = responseLoginModel as? ResponseLoginModel else {
                    print("Error: Invalid response structure")
                    return
                }
                
                let accessToken = responseLoginModel.data.accessToken
                
                TokenService.shared.saveToken(accessToken)
                
                DispatchQueue.main.async {
                    let vc = CustomMainTabBar()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                // Handle login failure, display an error message, etc.
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
        // Panggil API untuk login
        //               APIManager.shareInstance.login(email: email, password: password) { result in
        //                   switch result {
        //                   case .success(let user):
        //                       // Login berhasil, lakukan sesuatu jika diperlukan (seperti menampilkan pesan, navigasi, dll.)
        //
        //                       let accessToken = responseModel.data.accessToken
        //
        //                       print("User logged in: \(user)")
        //                   case .failure(let error):
        //                       // Tampilkan pesan kesalahan jika login gagal
        //                       self.showAlert(title: "Error", message: "Login failed. \(error.localizedDescription)")
        //                   }
        //               }
        
        // ------------------------------------------------
        
        //        let modelLogin = LoginModel(email: email, password: password)
        //
        //        APIManager.shareInstance.login(login: modelLogin) { [weak self] (result) in
        //            switch result {
        //            case .success(let json):
        //                guard let responseModel = json as? ResponseModel else {
        //                    print("Error: Invalid response structure")
        //                    return
        //                }
        //
        //                let accessToken = responseModel.data.accessToken
        //                let user = responseModel.data.user
        //
        //                let name = user.name
        //                let email = user.email
        //                let username = user.username
        //                let profilePhotoURL = user.profilePhotoURL
        //
        //                TokenService.shared.saveToken(accessToken)
        //
        //                DispatchQueue.main.async {
        //                    let vc = CustomMainTabBar()
        //                    self?.navigationController?.pushViewController(vc, animated: true)
        //                }
        // ------------------------------------------------
        //                //                let name = (json as AnyObject).value(forKey: "name") as! String
        //                //                let email = (json as AnyObject).value(forKey: "email") as! String
        //                //                let username = (json as AnyObject).value(forKey: "username") as! String
        //                //                let phone = (json as AnyObject).value(forKey: "phone") as! String
        //                //                let profile_photo_url = (json as AnyObject).value(forKey: "profile_photo_url") as! String
        //                //                let modelLoginResponse = LoginResponseModel(name: name, email: email, username: username, phone: phone, profile_photo_url: profile_photo_url)
        //                //                print(modelLoginResponse)
        // ------------------------------------------------
        //            case .failure(let err):
        //                print(err.localizedDescription)
        //            }
        //        }
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTextFields() {
        emailTextFieldCustom.configure(title: "Email", image: UIImage(named: "ic_email"), placeholder: "Your Email Address")
        
        passwordTextFieldCustom.configure(title: "Password", image: UIImage(named: "ic_password"), placeholder: "Your Password")
    }
    
    
}
