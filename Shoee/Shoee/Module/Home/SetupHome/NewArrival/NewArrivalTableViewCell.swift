import UIKit
import Kingfisher
import SkeletonView

class NewArrivalTableViewCell: BaseTableCell {

    @IBOutlet weak var imageData: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageData.layer.cornerRadius = 20

        // Konfigurasi penampilan SkeletonView
        SkeletonAppearance.default.tintColor = UIColor.gray
        SkeletonAppearance.default.gradient = SkeletonGradient(baseColor: .lightGray, secondaryColor: .darkGray)
        SkeletonAppearance.default.multilineHeight = 10
        SkeletonAppearance.default.multilineSpacing = 5
    }

    func configure(name: String, price: String, imageURL: String, category: String) {
        nameProduct.text = name
        priceProduct.text = price
        categoryLabel.text = category

        if let url = URL(string: imageURL) {
            imageData.showAnimatedGradientSkeleton() // menampilkan efek loading gelap
            imageData.kf.setImage(with: url) { [weak self] _ in
                self?.imageData.hideSkeleton() // menyembunyikan efek loading setelah gambar dimuat
            }
        } else {
            // Handle the case where imageURL is not a valid URL
            imageData.image = nil
            imageData.hideSkeleton()
        }
    }
}
