import UIKit
import SkeletonView
import Kingfisher

protocol FavoriteTableViewCellDelegate: AnyObject {
    func favoriteButtonTapped(for cell: FavoriteTableViewCell)
    // You can add more methods as needed for interactions with the parent
}

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    
    weak var delegate: FavoriteTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        imageProduct.layer.cornerRadius = 15
        viewContainer.layer.cornerRadius = 15
        imageProduct.showAnimatedGradientSkeleton()
        imageProduct.isUserInteractionEnabled = true
    }

    var imageURL: URL? {
        didSet {
            loadImage()
        }
    }

    private func loadImage() {
        guard let imageURL = imageURL else {
            imageProduct.hideSkeleton()
            imageProduct.image = nil
            return
        }

        let processor = DownsamplingImageProcessor(size: imageProduct.bounds.size)
        imageProduct.kf.indicatorType = .activity
        imageProduct.kf.setImage(
            with: imageURL,
            placeholder: nil,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]) { result in
                switch result {
                case .success(_):
                    self.imageProduct.hideSkeleton()
                case .failure(_):
                    self.imageProduct.hideSkeleton()
                }
        }
    }

    @IBAction func favoriteButtonPressed(_ sender: Any) {
        delegate?.favoriteButtonTapped(for: self)
    }

    // Configure the cell with product information
    func configure(name: String, price: String, imageURL: URL) {
        nameProduct.text = name
        priceProduct.text = price
        self.imageURL = imageURL
    }
}
