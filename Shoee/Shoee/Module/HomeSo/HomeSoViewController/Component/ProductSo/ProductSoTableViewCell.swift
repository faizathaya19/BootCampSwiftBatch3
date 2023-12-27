import UIKit

class ProductSoTableViewCell: BaseTableCell {
    
    @IBOutlet weak var imageData: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageData.makeCornerRadius(20)
    }
    
    func configure(name: String, price: String, imageURL: String, category: String) {
        nameProduct.text = name
        priceProduct.text = price
        categoryLabel.text = category
        
        if let url = URL(string: imageURL) {
            imageData.kf.setImage(with: url)
        } else {
            imageData.image = nil
        }
    }
}


