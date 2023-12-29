import UIKit

class AddressTableViewCell: BaseTableCell {

  
    @IBOutlet weak var textAddress: UILabel!
    @IBOutlet weak var containerAddress: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerAddress.makeCornerRadius(15)
    }

    
}
