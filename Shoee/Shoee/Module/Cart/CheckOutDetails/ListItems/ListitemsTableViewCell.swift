import UIKit
import Alamofire
import SkeletonView

class ListitemsTableViewCell: BaseTableCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var quantityNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageProduct.layer.cornerRadius = 15
        viewContainer.layer.cornerRadius = 15
        

    }
    
    func configure(withQuantity quantity: Int, price: Double, productName: String, imageURL: URL) {
        quantityNumber.text = "\(quantity)"
        priceProduct.text = "\(price)"
        nameProduct.text = productName

        // Apply SkeletonView placeholder for the image
        imageProduct.showAnimatedGradientSkeleton()

        // Download image using Alamofire
        AF.request(imageURL).responseData { [weak self] response in
            guard let data = response.data, let image = UIImage(data: data) else {
                // If there's an error or no data, you may want to handle this case (e.g., show an error image)
                return
            }

            // Hide SkeletonView placeholder
            self?.imageProduct.hideSkeleton()

            // Set downloaded image to UIImageView
            self?.imageProduct.image = image
        }
    }


    
}
