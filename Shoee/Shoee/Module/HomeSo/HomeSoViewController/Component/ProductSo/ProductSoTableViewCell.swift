import UIKit
import Kingfisher

class ProductSoTableViewCell: BaseTableCell {
    
    @IBOutlet weak var imageData: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageData.layer.cornerRadius = 20
    }
    
    func configure(name: String, price: String, imageURL: String, category: String) {
        nameProduct.text = name
        priceProduct.text = price
        categoryLabel.text = category
        
        if let url = URL(string: imageURL) {
            let processor = DownsamplingImageProcessor(size: imageData.bounds.size)
            imageData.kf.indicatorType = .activity
            imageData.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]) { _ in
                }
        } else {
            imageData.image = nil
        }
    }
}
