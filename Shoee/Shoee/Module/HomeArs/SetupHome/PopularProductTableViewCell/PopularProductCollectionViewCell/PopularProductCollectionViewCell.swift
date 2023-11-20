import UIKit
import Kingfisher
import SkeletonView

class PopularProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popularImage: UIImageView!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var titleCategoryProduct: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 15
        popularImage.isSkeletonable = true
        priceText.isSkeletonable = true
        productName.isSkeletonable = true
        titleCategoryProduct.isSkeletonable = true
    }

    func configure(name: String?, price: String?, imageURL: String?, category: String?) {
        productName.text = name
        priceText.text = price
        titleCategoryProduct.text = category

        if let url = URL(string: imageURL ?? "") {
            popularImage.showSkeleton() // menampilkan efek loading
            popularImage.kf.setImage(with: url) { [weak self] _ in
                self?.popularImage.hideSkeleton() // menyembunyikan efek loading setelah gambar dimuat
            }
        } else {
            // Handle the case where imageURL is not a valid URL
            popularImage.image = nil
            popularImage.hideSkeleton()
        }
    }
}
