import UIKit

protocol CencelPaymentCellDelegate: AnyObject {
    func cencelPaymentBtn(inCell cell: CencelPaymentTableViewCell)
}

class CencelPaymentTableViewCell: UITableViewCell {

    weak var delegate: CencelPaymentCellDelegate?
    
    
    @IBAction func cencelPaymentBtn(_ sender: Any) {
        delegate?.cencelPaymentBtn(inCell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
