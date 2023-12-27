import UIKit
import Alamofire
import SkeletonView

protocol CartTableViewCellDelegate: AnyObject {
    func didDeleteItem(withProductID productID: Int)
    func quantityDidChange(in cell: CartTableViewCell, newQuantity: Int)
}

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
            delegate?.quantityDidChange(in: self, newQuantity: quantity)
        }
    }

    var productID: Int = 0
    weak var delegate: CartTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        imageProduct.makeCornerRadius(15)
        viewContainer.makeCornerRadius(15)

        addQuantityBtn.addTarget(self, action: #selector(addQuantity), for: .touchUpInside)
        removeQuantityBtn.addTarget(self, action: #selector(removeQuantity), for: .touchUpInside)
        deleteProductBtn.addTarget(self, action: #selector(deleteProduct), for: .touchUpInside)
    }
    func configure(withQuantity quantity: Int, price: Double, productName: String, imageURL: URL) {
        self.quantity = quantity
        priceProduct.text = "\(price)"
        nameProduct.text = productName

        imageProduct.showAnimatedGradientSkeleton(usingGradient: Constants.skeletonColor)

        AF.request(imageURL).responseData { [weak self] response in
            guard let data = response.data, let image = UIImage(data: data) else {
                return
            }
            
            self?.imageProduct.hideSkeleton()

            self?.imageProduct.image = image
        }
    }


    @objc private func addQuantity() {
        quantity += 1
    }

    @objc private func removeQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }

    @objc private func deleteProduct() {
        delegate?.didDeleteItem(withProductID: productID)
    }
}
