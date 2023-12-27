import UIKit
import Kingfisher

class HeaderSoTableViewCell: BaseTableCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.applyCircularRadius()
    }

    func configureHeader(name: String?, username: String?, imageURLString: String?, skeletonView: Bool) {
        nameLabel.text = name
        usernameLabel.text = username
        isSkeletonable = skeletonView

        let encodedName = name?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""

        let avatarURLString = "https://ui-avatars.com/api/?name=\(encodedName)&color=7F9CF5&background=EBF4FF"

        if let imageURL = URL(string: avatarURLString) {
            profileImage.kf.setImage(with: imageURL)
        }
    }
}
