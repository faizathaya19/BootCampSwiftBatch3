import UIKit
import Kingfisher
import SkeletonView

protocol FavoriteTableViewCellDelegate: AnyObject {
    func favoriteButtonTapped(for cell: FavoriteTableViewCell)
    func deleteButtonTapped(for cell: FavoriteTableViewCell)
    // Add more methods as needed
}

class FavoriteTableViewCell: BaseTableCell {
    
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var priceProduct: UILabel!
    @IBOutlet private weak var nameProduct: UILabel!
    @IBOutlet private weak var imageProduct: UIImageView!
    @IBOutlet private weak var deleteButton: UIButton!
    
    weak var delegate: FavoriteTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    var imageURL: URL? {
        didSet {
            loadImage()
        }
    }
    
    // MARK: - Configuration
    
    private func configureUI() {
        imageProduct.layer.cornerRadius = 15
        viewContainer.layer.cornerRadius = 15
        imageProduct.showAnimatedGradientSkeleton()
        imageProduct.isUserInteractionEnabled = true
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        deleteButton.backgroundColor = .systemPink
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2.0
        deleteButton.layer.masksToBounds = true
    }
    
    
    // MARK: - Image Loading
    
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
            ]) { [weak self] result in
                switch result {
                case .success(_):
                    self?.imageProduct.hideSkeleton()
                case .failure(_):
                    self?.imageProduct.hideSkeleton()
                }
            }
    }
    
    // MARK: - Actions
    
    @objc private func deleteButtonPressed() {
        delegate?.deleteButtonTapped(for: self)
    }
    
    // MARK: - Public Methods
    
    func configure(name: String, price: String, imageURLString: String) {
        nameProduct.text = name
        priceProduct.text = price
        if let imageURL = URL(string: imageURLString) {
            self.imageURL = imageURL
        }
    }
}
