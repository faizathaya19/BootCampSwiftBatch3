import UIKit

class ChatReceiverTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chatMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        applyCornerRadius()
    }

    private func applyCornerRadius() {
        // Set corner radius for each corner
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}
