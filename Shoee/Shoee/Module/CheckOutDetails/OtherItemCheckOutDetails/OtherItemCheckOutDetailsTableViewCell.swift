import UIKit

protocol OtherItemCheckOutDetailsCellDelegate: AnyObject {
    func checkOutButtonTapped(inCell cell: OtherItemCheckOutDetailsTableViewCell)
}

class OtherItemCheckOutDetailsTableViewCell: BaseTableCell {

    @IBOutlet weak var buttonCheckOut: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var subPriceLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var paymentSummaryContainerView: UIView!
  
    weak var delegate: OtherItemCheckOutDetailsCellDelegate?
    
    var checkOutButtonAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func configure(productQuantity: Int, productPrice: String, totalPrice: String) {
        totalItemsLabel.text = "\(productQuantity)"
        subPriceLabel.text = "\(productPrice)"
        totalPriceLabel.text = "\(totalPrice)"
    }

    @IBAction func checkOutButtonTapped(_ sender: UIButton) {
            delegate?.checkOutButtonTapped(inCell: self)
        }

    private func setupUI() {
        paymentSummaryContainerView.makeCornerRadius(15)
    }
}
