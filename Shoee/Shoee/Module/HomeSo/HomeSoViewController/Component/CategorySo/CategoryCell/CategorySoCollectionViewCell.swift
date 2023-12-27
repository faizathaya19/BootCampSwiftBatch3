import UIKit

class CategorySoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.setCornerRadiusWith(radius: 15, borderWidth: 1, borderColor: .gray)
    }
    
    func configureAppearance(selected: Bool, skeletonView: Bool) {
        viewContainer.backgroundColor = selected ? Constants.primary : UIColor.clear
        viewContainer.layer.borderWidth = selected ? 0 : 1.0
        viewContainer.layer.borderColor = selected ? UIColor.clear.cgColor : UIColor.gray.cgColor
        categoryTitle.textColor = selected ? Constants.primaryText : Constants.secondaryText
        categoryTitle.font = selected ? UIFont.boldSystemFont(ofSize: categoryTitle.font.pointSize) : UIFont.systemFont(ofSize: categoryTitle.font.pointSize, weight: .regular)
        isSkeletonable = skeletonView
    }
}
