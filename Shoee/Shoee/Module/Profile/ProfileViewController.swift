import UIKit
import Kingfisher
import SkeletonView

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    lazy var popUpLoading = PopUpLoading(on: view)
    
    var userData: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpLoading.dismissImmediately()
        profileImage.applyCircularRadius()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUsers()
    }
    
    @IBAction func btnEditProfile(_ sender: Any) {
        let vc = EditProfileViewController()
        vc.userData = userData
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func privacyAndPolicyBtn(_ sender: Any) {
        let vc = PrivacyAndPolicyViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func yourorders(_ sender: Any) {
        let vc = YourOrdersViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func termAndServiceBtn(_ sender: Any) {
        let vc = TermsAndServiceViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        
        popUpLoading.showInFull()
        
        APIManager.shared.makeAPICall(endpoint: .logout(vc: self)) {
            (result: Result<ResponseLogoutModel, Error>) in
            switch result {
            case .success(let responseLogout):
                TokenService.shared.deleteToken()
                UserDefaultManager.deleteUserID()
                
                self.popUpLoading.dismissImmediately()
                
                let loginViewController = LoginViewController()
                let navigationController = UINavigationController(rootViewController: loginViewController)
                UIApplication.shared.keyWindow?.rootViewController = navigationController
                
            case .failure(let error):
                self.popUpLoading.dismissImmediately()
                self.showCustomAlertWith(
                    detailResponseOkAction: nil,
                    title: "Error",
                    message: error.localizedDescription,
                    image: #imageLiteral(resourceName: "ic_error"),
                    actions: nil)
            }
        }
    }
    
    
    private func configureHeader() {
        guard let user = userData else {
            return
        }
        
        nameUser.text = user.name.components(separatedBy: " ").first ?? ""
        username.text = user.username
        
        let encodedName = user.name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let avatarURLString = "https://ui-avatars.com/api/?name=\(encodedName)&color=7F9CF5&background=EBF4FF"
        
        if let imageURL = URL(string: avatarURLString) {
            profileImage.kf.setImage(with: imageURL)
            
            
        }
        
    }
    
    private func fetchUsers() {
        username.showAnimatedGradientSkeleton(usingGradient: Constants.skeletonColor)
        nameUser.showAnimatedGradientSkeleton(usingGradient: Constants.skeletonColor)
        profileImage.showAnimatedGradientSkeleton(usingGradient: Constants.skeletonColor)

        APIManager.shared.makeAPICall(endpoint: .user) { [weak self] (result: Result<ResponseUserModel, Error>) in
            switch result {
            case .success(let response):
                self?.userData = response.data
                self?.username.hideSkeleton()
                self?.nameUser.hideSkeleton()
                self?.profileImage.hideSkeleton()
                
                self?.configureHeader()
            case .failure(_):
               break
            }
        }
    }

}
