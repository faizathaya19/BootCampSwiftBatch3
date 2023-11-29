import UIKit

protocol OtherItemCheckOutDetailsCellDelegate: AnyObject {
    func checkOutButtonTapped(inCell cell: OtherItemCheckOutDetailsTableViewCell)
}

class OtherItemCheckOutDetailsTableViewCell: BaseTableCell {

    @IBOutlet weak var buttonCheckOut: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var subPriceLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var yourAddressLabel: UILabel!
    @IBOutlet weak var yourAddressContainerView: UIView!
    @IBOutlet weak var storeLocationContainerView: UIView!
    @IBOutlet weak var paymentSummaryContainerView: UIView!
    @IBOutlet weak var addressDetailContainerView: UIView!
    
    weak var delegate: OtherItemCheckOutDetailsCellDelegate?
    
    var checkOutButtonAction: (() -> Void)?
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCornerRadius()
    }
    
    // MARK: - Configuration

    func configure(address: String, productQuantity: Int, productPrice: Double, totalPrice: Double) {
        yourAddressLabel.text = address
        totalItemsLabel.text = "\(productQuantity)"
        subPriceLabel.text = "\(productPrice)"
        totalPriceLabel.text = "\(totalPrice)"
    }

    // MARK: - Actions

    @IBAction func checkOutButtonTapped(_ sender: UIButton) {
            delegate?.checkOutButtonTapped(inCell: self)
        }


    // MARK: - Private Methods

    private func setupCornerRadius() {
        yourAddressContainerView.layer.cornerRadius = yourAddressContainerView.frame.height / 2
        storeLocationContainerView.layer.cornerRadius = storeLocationContainerView.frame.height / 2
        paymentSummaryContainerView.layer.cornerRadius = 15
        addressDetailContainerView.layer.cornerRadius = 15
    }
}
