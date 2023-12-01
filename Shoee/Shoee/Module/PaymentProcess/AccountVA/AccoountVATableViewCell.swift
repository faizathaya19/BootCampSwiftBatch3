import UIKit

protocol AccoountVACellDelegate: AnyObject {
    func goToOrderDetails(inCell cell: AccoountVATableViewCell)
    func goToHome(inCell cell: AccoountVATableViewCell)
}

class AccoountVATableViewCell: BaseTableCell {

    @IBOutlet weak var containerVABottom: UIView!
    @IBOutlet weak var containerVATop: UIView!
    @IBOutlet weak var containerButton: UIView!
    
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
        // Apply corner radius to bottom right and bottom left corners
        containerButton.layer.cornerRadius = cornerRadius
        containerButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        // Apply corner radius to top right and top left corners
        containerVATop.layer.cornerRadius = cornerRadius
        containerVATop.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
