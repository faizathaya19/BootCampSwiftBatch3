import UIKit
import SkeletonView

class CategoryListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var categoryTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Set corner radius
        self.viewContainer.layer.cornerRadius = 15

        // Add border
        self.viewContainer.layer.borderWidth = 1.0
        self.viewContainer.layer.borderColor = UIColor.gray.cgColor

        // Enable skeleton animation
        self.categoryTitle.isSkeletonable = true
        self.viewContainer.isSkeletonable = true
    }

    func showSkeleton() {
        // Start skeleton animation
        self.categoryTitle.showSkeleton()
        self.viewContainer.showSkeleton()
    }

    func hideSkeleton() {
        // Stop skeleton animation
        self.categoryTitle.hideSkeleton()
        self.viewContainer.hideSkeleton()
    }
}
