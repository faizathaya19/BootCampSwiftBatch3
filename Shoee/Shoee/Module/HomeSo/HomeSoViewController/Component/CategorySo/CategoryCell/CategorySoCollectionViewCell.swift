import UIKit

class CategorySoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContainer.layer.cornerRadius = 15

        self.viewContainer.layer.borderWidth = 1.0
        self.viewContainer.layer.borderColor = UIColor.gray.cgColor
    }
    
    func configureAppearance(selected: Bool) {
        viewContainer.backgroundColor = selected ? UIColor(named: "Primary") : UIColor.clear
        viewContainer.layer.borderWidth = selected ? 0 : 1.0
        viewContainer.layer.borderColor = selected ? UIColor.clear.cgColor : UIColor.gray.cgColor
        categoryTitle.textColor = selected ? UIColor(named: "PrimaryText") : UIColor(named: "SecondaryText")
        categoryTitle.font = selected ? UIFont.boldSystemFont(ofSize: categoryTitle.font.pointSize) : UIFont.systemFont(ofSize: categoryTitle.font.pointSize, weight: .regular)
    }
}
