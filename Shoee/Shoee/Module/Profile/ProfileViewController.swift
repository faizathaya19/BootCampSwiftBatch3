import UIKit

class ProfileViewController: UIViewController {

    @IBAction func btnEditProfile(_ sender: Any) {
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
