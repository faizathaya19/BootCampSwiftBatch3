import UIKit

protocol AccoountVACellDelegate: AnyObject {
    func goToOrderDetails(inCell cell: AccoountVATableViewCell)
    func goToHome(inCell cell: AccoountVATableViewCell)
}

class AccoountVATableViewCell: BaseTableCell {

    @IBOutlet weak var totalPaymentLabel: UILabel!
    @IBOutlet weak var numberVALabel: UILabel!
    @IBOutlet weak var containerVABottom: UIView!
    @IBOutlet weak var containerVATop: UIView!
    @IBOutlet weak var containerButton: UIView!
    
    @IBOutlet weak var imageBank: UIImageView!
    @IBOutlet weak var containerImage: UIView!
    
    weak var delegate: AccoountVACellDelegate?
    
    let cornerRadius: CGFloat = 15.0
    
    @IBAction func goToOrderDetails(_ sender: Any) {
        delegate?.goToOrderDetails(inCell: self)
    }
    
    @IBAction func goToHome(_ sender: Any) {
        delegate?.goToHome(inCell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerVABottom.layer.cornerRadius = cornerRadius
        containerImage.layer.cornerRadius = 5
        containerButton.layer.cornerRadius = cornerRadius
        containerButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerVATop.layer.cornerRadius = cornerRadius
        containerVATop.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func configure(totalPayment: String, numberVA: String, bankImageName: String) {
        totalPaymentLabel.text = totalPayment
        numberVALabel.text = numberVA
        imageBank.image = UIImage(named: bankImageName)
    }

}
