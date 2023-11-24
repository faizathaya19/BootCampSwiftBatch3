import UIKit

class EmptyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageEmpty: UIImageView!
    @IBOutlet weak var messageEmpty: UILabel!
    @IBOutlet weak var titleEmpty: UILabel!
    
    @IBAction func btnAction(_ sender: Any) {
        let customMainTabBar = CustomMainTabBar()
        let navigationController = UINavigationController(rootViewController: customMainTabBar)

        // Access the windowScene from the current scene delegate
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // Set the root view controller to the navigation controller
            sceneDelegate.window?.rootViewController = navigationController
        }
    }
    
    func configure(withImageNamed imageName: String, message: String, title: String) {
        imageEmpty.image = UIImage(named: imageName)
        messageEmpty.text = message
        titleEmpty.text = title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
