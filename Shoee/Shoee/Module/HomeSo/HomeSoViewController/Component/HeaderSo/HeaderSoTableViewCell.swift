import UIKit
import Kingfisher

class HeaderSoTableViewCell: BaseTableCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius =  profileImage.frame.height / 2
    }

    func configureHeader(name: String?, username: String?, imageURLString: String?) {
        nameLabel.text = name
        usernameLabel.text = username

        let encodedName = name?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""

        let avatarURLString = "https://ui-avatars.com/api/?name=\(encodedName)&color=7F9CF5&background=EBF4FF"

        if let imageURL = URL(string: avatarURLString) {
            // Use Kingfisher to load the image asynchronously
            profileImage.kf.setImage(with: imageURL)
        }
    }
}
