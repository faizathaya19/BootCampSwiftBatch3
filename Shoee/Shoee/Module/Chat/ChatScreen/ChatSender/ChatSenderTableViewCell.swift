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
        setupUI()
    }
    
    func setupUI(){
        imageProfileSender.applyCircularRadius()
        btnAddToCart.setCornerRadiusWith(radius: 10, borderWidth: 1.0, borderColor: UIColor(named: "Primary")!)
        containerAskProduct.makeCornerRadius(20)
        btnBuyNow.makeCornerRadius(10)
        imageProductAsk.makeCornerRadius(15)
        containerView.makeCornerRadius(20, maskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner])
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
