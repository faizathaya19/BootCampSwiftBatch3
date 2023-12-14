import UIKit

protocol ChatSenderCellDelegate: AnyObject {
    func didTapAddToCart(in cell: ChatSenderTableViewCell)
    func didTapBuyNow(in cell: ChatSenderTableViewCell)
}

class ChatSenderTableViewCell: BaseTableCell {
    @IBOutlet weak var imageProductAsk: UIImageView!
    @IBOutlet weak var containerAskProduct: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chatMessage: UILabel!
    @IBOutlet weak var containerImageProfile: UIView!
    @IBOutlet weak var priceAskProduct: UILabel!
    @IBOutlet weak var imageProfileSender: UIImageView!
    @IBOutlet weak var productAskName: UILabel!
    @IBOutlet weak var btnAddToCart: UIButton!
    
    @IBOutlet weak var btnBuyNow: UIButton!
    
    weak var delegate: ChatSenderCellDelegate?
    
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        delegate?.didTapAddToCart(in: self)
    }
    
    
    @IBAction func buyNowButtonTapped(_ sender: Any) {
        delegate?.didTapBuyNow(in: self)
    }
    
    
    var containerAskProductIsHidden: Bool = false {
        didSet {
            containerAskProduct.isHidden = containerAskProductIsHidden
        }
    }
    
    var imageProfileSenderIsHidden: Bool = true {
        didSet {
            containerImageProfile.isHidden = imageProfileSenderIsHidden
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageProfileSender.layer.cornerRadius = imageProfileSender.frame.height / 2
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,  .layerMinXMaxYCorner]
        btnAddToCart.layer.cornerRadius = 10
        btnBuyNow.layer.cornerRadius = 10
        imageProductAsk.layer.cornerRadius = 15
        containerAskProduct.layer.cornerRadius = 20
        containerAskProduct.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        btnAddToCart.layer.borderWidth = 1.0
        btnAddToCart.layer.borderColor = UIColor(named: "Primary")?.cgColor
    }
    
    func configure(with message: MessageModel ) {
        productAskName.text = message.data.product?.productName
        priceAskProduct.text =  "\(message.data.product?.price ?? 0)"
        chatMessage.text = message.data.message

        let encodedName = message.data.username.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let avatarURLString = "https://ui-avatars.com/api/?name=\(encodedName)&color=7F9CF5&background=EBF4FF"
        if let imageURL = URL(string: avatarURLString) {
            imageProfileSender.kf.setImage(with: imageURL)
        }
        
        if let imageURL = URL(string: message.data.product?.image ?? "") {
            imageProductAsk.kf.setImage(with: imageURL)
        }
    }
}
