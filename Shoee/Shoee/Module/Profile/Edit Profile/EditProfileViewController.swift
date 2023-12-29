import UIKit
import Kingfisher

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    var userData: UserModel?
    lazy var popUpLoading = PopUpLoading(on: view)
    
    @IBAction func btnCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBAction func editBtnProfile(_ sender: Any) {
        guard let name = nameTF.text, !name.isEmpty else {
            nameTF.text = userData?.name
            return
        }
        
        guard let username = usernameTF.text, !username.isEmpty else {
            usernameTF.text = userData?.username
            return
        }
        
        guard let email = emailTF.text, !email.isEmpty else {
            emailTF.text = userData?.email
            return
        }
        
        if !isValidEmail(email) {
            handleError(message: "Please enter a valid email address")
            return
        }
        
        
        guard let phone = phoneTF.text, !phone.isEmpty else {
            phoneTF.text = userData?.phone
            return
        }
        
        let actionYes: [String: () -> Void] = ["Yes": { [weak self] in
            let editProfileParams = EditProfileParam(name: name, email: email, username: username, phone: phone)
            self?.performLogin(with: editProfileParams)
        }]
        
        let actionNo: [String: () -> Void] = ["X": { }]
        
        let arrayActions = [actionYes, actionNo]
        
        showCustomAlertWith(
            title: "Edit Profile",
            message: "are you sure edit ur profile?",
            image: #imageLiteral(resourceName: "ic_success"),
            actions: arrayActions
        )
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeader()
        phoneTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hidesBottomBarWhenPushed = true
        navigationController?.isNavigationBarHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        return phoneTF.validatePhoneNumberInput(in: range, replacementString: string, maxLength: 14)
        
    }
    
    
    private func configureHeader() {
        guard let user = userData else {
            return
        }
        
        nameTF.text = user.name
        usernameTF.text = user.username
        emailTF.text = user.email
        phoneTF.text = user.phone
        
        let encodedName = user.name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let avatarURLString = "https://ui-avatars.com/api/?name=\(encodedName)&color=7F9CF5&background=EBF4FF"
        
        if let imageURL = URL(string: avatarURLString) {
            profileImage.kf.setImage(with: imageURL)
            
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
    func performLogin(with editProfileParams: EditProfileParam) {
        
        self.popUpLoading.showInFull()
        
        APIManager.shared.makeAPICall(endpoint: .editProfile(editProfileParams)) { [weak self] (result: Result<ResponseUserModel, Error>) in
            
            switch result {
            case .success(let responseLoginModel):
                
                self?.popUpLoading.dismissAfter1()
                
                self?.userData = responseLoginModel.data
                
            case .failure(_):
                break
            }
        }
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
}
