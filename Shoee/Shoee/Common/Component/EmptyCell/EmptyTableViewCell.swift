import UIKit

class EmptyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageEmpty: UIImageView!
    @IBOutlet weak var messageEmpty: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var titleEmpty: UILabel!
    
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
