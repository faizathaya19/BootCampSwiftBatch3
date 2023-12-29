import UIKit
import Alamofire

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

    func configure(withQuantity quantity: Int, price: Double, productName: String, imageURL: String) {
        quantityNumber.text = "\(quantity)"
        priceProduct.text = "\(price)"
        nameProduct.text = productName
        
        if let url = URL(string: imageURL) {
            imageProduct.kf.setImage(with: url)
        } else {
           
            imageProduct.image = nil
        }
    }


    
}
