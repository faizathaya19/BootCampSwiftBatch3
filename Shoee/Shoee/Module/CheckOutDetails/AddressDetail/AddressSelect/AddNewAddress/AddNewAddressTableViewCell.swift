import UIKit

protocol AddNewAddressCellDelegate: AnyObject {
    func didTapAddNewAddress(_ addressText: String)
}

class AddNewAddressTableViewCell: BaseTableCell {
    
    @IBOutlet weak var messageTextView: UITextView!
    
    weak var delegate: AddNewAddressCellDelegate?
    
    @IBAction func addNewAddress(_ sender: Any) {
        if let addressText = messageTextView.text, !addressText.isEmpty {
            delegate?.didTapAddNewAddress(addressText)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Additional setup code if needed
    }
}
