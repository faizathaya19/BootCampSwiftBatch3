import UIKit

protocol AccoountVACellDelegate: AnyObject {
    func goToOrderDetails(inCell cell: AccoountVATableViewCell)
    func goToHome(inCell cell: AccoountVATableViewCell)
    func copyVANumber(inCell cell: AccoountVATableViewCell)
}

class AccoountVATableViewCell: BaseTableCell {

    @IBAction func copyVANumber(_ sender: Any) {
        delegate?.copyVANumber(inCell: self)
    }
    @IBOutlet weak var totalPaymentLabel: UILabel!
    @IBOutlet weak var numberVALabel: UILabel!
    @IBOutlet weak var containerVABottom: UIView!
    @IBOutlet weak var containerVATop: UIView!
    
    @IBOutlet weak var imageBank: UIImageView!
    @IBOutlet weak var containerImage: UIView!
    
    weak var delegate: AccoountVACellDelegate?
    
    @IBAction func goToOrderDetails(_ sender: Any) {
        delegate?.goToOrderDetails(inCell: self)
    }
    
    @IBAction func goToHome(_ sender: Any) {
        delegate?.goToHome(inCell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerVATop.makeCornerRadius(15)
        containerImage.makeCornerRadius(5)
        containerVABottom.makeCornerRadius(15)
    }

    func configure(totalPayment: String, numberVA: String, bankImageName: String) {
        totalPaymentLabel.text = totalPayment
        numberVALabel.text = numberVA
        imageBank.image = UIImage(named: bankImageName)
    }

}
