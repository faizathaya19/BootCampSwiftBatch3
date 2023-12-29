import UIKit

class PaymentSelectItemTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSelectItem: UILabel!
    @IBOutlet weak var imageItemSelect: UIImageView!
    @IBOutlet weak var containerImage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageItemSelect.makeCornerRadius(15)
        containerImage.makeCornerRadius(15)
    }
    
    func configure(data image: String, name: String) {
        labelSelectItem.text = name
        imageItemSelect.image = UIImage(named: image)
    }
    
}
