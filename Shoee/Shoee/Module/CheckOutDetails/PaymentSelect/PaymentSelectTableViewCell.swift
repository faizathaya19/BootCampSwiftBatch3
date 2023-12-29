import UIKit

class PaymentSelectTableViewCell: BaseTableCell {

    @IBOutlet weak var conteinerView: UIView!
    
    @IBOutlet weak var containerImage: UIView!
    @IBOutlet weak var paymentNameLabel: UILabel!
    @IBOutlet weak var paymentSelectImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        conteinerView.makeCornerRadius(15)
        paymentSelectImage.makeCornerRadius(15)
        containerImage.makeCornerRadius(15)
    }

    func configure(data image: String, name: String, hideimage: Bool = false) {
        paymentNameLabel.text = name
        containerImage.isHidden = hideimage
        paymentSelectImage.image = UIImage(named: image)
    }
}
