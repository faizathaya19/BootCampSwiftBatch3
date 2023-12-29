import UIKit
import Kingfisher
import SkeletonView

protocol FavoriteTableViewCellDelegate: AnyObject {
    func favoriteButtonTapped(for cell: FavoriteTableViewCell)
    func deleteButtonTapped(for cell: FavoriteTableViewCell)
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
    
    private func configureUI() {
        imageProduct.makeCornerRadius(15)
        viewContainer.makeCornerRadius(15)
        imageProduct.showAnimatedGradientSkeleton(usingGradient: Constants.skeletonColor)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        deleteButton.backgroundColor = .systemPink
        deleteButton.applyCircularRadius()
        deleteButton.layer.masksToBounds = true
    }
    
    
    @objc private func deleteButtonPressed() {
        delegate?.deleteButtonTapped(for: self)
    }
    
    func configure(name: String, price: String, imageURLString: String) {
        nameProduct.text = name
        priceProduct.text = price
        if let url = URL(string: imageURLString) {
            imageProduct.kf.setImage(with: url)
        } else {
            
            imageProduct.image = nil
        }
    }
}
