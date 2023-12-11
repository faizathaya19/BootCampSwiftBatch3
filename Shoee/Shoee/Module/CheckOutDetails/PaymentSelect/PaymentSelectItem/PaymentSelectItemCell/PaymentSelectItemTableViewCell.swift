import UIKit

class PaymentSelectItemTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSelectItem: UILabel!
    @IBOutlet weak var imageItemSelect: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageItemSelect.layer.cornerRadius = 15

    }
    
    func configure(data image: String, name: String) {
        labelSelectItem.text = name
        
        if let image = UIImage(named: image) {
            imageItemSelect.image = image
        } else {
            imageItemSelect.image = UIImage(named: "defaultImage")
        }
    }
    
}
