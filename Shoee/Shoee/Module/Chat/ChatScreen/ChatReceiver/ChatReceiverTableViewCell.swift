import UIKit

class ChatReceiverTableViewCell: BaseTableCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chatMessage: UILabel!

    @IBOutlet weak var conteinerProfileReceiver: UIView!
    
    @IBOutlet weak var imageProfileReceiver: UIImageView!
    
    var imageProfileReceiverIsHidden: Bool = true {
        didSet {
            conteinerProfileReceiver.isHidden = imageProfileReceiverIsHidden
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCornerRadius()
    }

    private func applyCornerRadius() {
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
}
