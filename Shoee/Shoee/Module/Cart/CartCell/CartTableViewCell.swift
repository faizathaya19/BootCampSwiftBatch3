import UIKit

class CartTableViewCell: BaseTableCell {
    
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var priceProduct: UILabel!
    @IBOutlet private weak var nameProduct: UILabel!
    @IBOutlet private weak var imageProduct: UIImageView!
    @IBOutlet private weak var deleteProductBtn: UIButton!
    @IBOutlet weak var quantityNumber: UILabel!
    @IBOutlet weak var addQuantityBtn: UIButton!
    @IBOutlet weak var removeQuantityBtn: UIButton!
    
    var quantity: Int = 1 {
        didSet {
            quantityNumber.text = "\(quantity)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageProduct.layer.cornerRadius = 15
        viewContainer.layer.cornerRadius = 15
        
        addQuantityBtn.addTarget(self, action: #selector(addQuantity), for: .touchUpInside)
        removeQuantityBtn.addTarget(self, action: #selector(removeQuantity), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func addQuantity() {
        quantity += 1
        // You can add additional logic here, such as updating the total price, etc.
    }
    
    @objc private func removeQuantity() {
        if quantity > 1 {
            quantity -= 1
            // You can add additional logic here, such as updating the total price, etc.
        }
    }
    
}
