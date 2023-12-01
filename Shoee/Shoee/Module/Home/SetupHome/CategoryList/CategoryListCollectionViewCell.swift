import UIKit
import Kingfisher

class CategoryListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var categoryTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()


        self.viewContainer.layer.cornerRadius = 15

        self.viewContainer.layer.borderWidth = 1.0
        self.viewContainer.layer.borderColor = UIColor.gray.cgColor
    }

}
