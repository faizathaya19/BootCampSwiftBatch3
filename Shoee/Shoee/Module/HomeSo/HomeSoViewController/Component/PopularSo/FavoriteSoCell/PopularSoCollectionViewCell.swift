import UIKit
import Kingfisher

class PopularSoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popularImage: UIImageView!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var titleCategoryProduct: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 15
    }

    func configure(name: String?, price: String?, imageURL: String?, category: String?) {
        productName.text = name
        priceText.text = price
        titleCategoryProduct.text = category

        if let url = URL(string: imageURL ?? "") {
            let processor = DownsamplingImageProcessor(size: popularImage.bounds.size)
            popularImage.kf.indicatorType = .activity
            popularImage.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]) { _ in
                    // Handle completion if needed
                }
        } else {
            // Handle the case where imageURL is not a valid URL
            popularImage.image = nil
        }
    }
}
