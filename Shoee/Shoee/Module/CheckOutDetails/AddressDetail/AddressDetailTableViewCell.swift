import UIKit

class AddressDetailTableViewCell: BaseTableCell {
    @IBOutlet weak var addressDetailContainerView: UIView!
    @IBOutlet weak var yourAddressLabel: UILabel!
    @IBOutlet weak var yourAddressContainerView: UIView!
    @IBOutlet weak var storeLocationContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        yourAddressContainerView.applyCircularRadius()
        storeLocationContainerView.applyCircularRadius()
        addressDetailContainerView.makeCornerRadius(15)
    }
    
    func configure(address: String) {
        yourAddressLabel.text = address
    }
    
}
