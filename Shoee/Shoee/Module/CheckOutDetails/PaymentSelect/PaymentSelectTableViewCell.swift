import UIKit

class PaymentSelectTableViewCell: BaseTableCell {

    @IBOutlet weak var conteinerView: UIView!
    
    @IBOutlet weak var paymentNameLabel: UILabel!
    @IBOutlet weak var paymentSelectImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        conteinerView.layer.cornerRadius = 15
        paymentSelectImage.layer.cornerRadius = 15
    }

    func configure(data image: String, name: String, hideimage: Bool = false) {
        paymentNameLabel.text = name
        paymentSelectImage.isHidden = hideimage
        
        if let image = UIImage(named: image) {
            paymentSelectImage.image = image
        } else {
            paymentSelectImage.image = UIImage(named: "defaultImage")
        }
    }
}
