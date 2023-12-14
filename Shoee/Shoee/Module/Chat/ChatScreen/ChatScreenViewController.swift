import UIKit
import Firebase

class ChatScreenViewController: UIViewController {
    @IBOutlet weak var massageViewContainer: UIView!
    @IBOutlet weak var nameProductAsk: UILabel!
    @IBOutlet weak var priceProductAsk: UILabel!
    @IBOutlet weak var chatScreenTableView: UITableView!
    @IBOutlet weak var heightMessageTextView: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView! {
        didSet {
            messageText = messageTextView.text
        }
    }

    
    @IBOutlet weak var imageAskProduct: UIImageView!
    @IBOutlet weak var btnCancelAskProduct: UIButton!
    @IBOutlet weak var askProductViewContainter: UIView!
    
    let userId = UserDefaultManager.getUserID()
    var messageData: [MessageModel] = []
    var productAsk: ProductModel?
    var messageText: String = ""
    let messageRef = Database.database().reference().child("messages")
    var productAskIsHidden: Bool = true
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        scrollToBottom()
        configureProductView()
        observeMessages()
    }
    
    func setupUI() {
        btnCancelAskProduct.layer.cornerRadius = btnCancelAskProduct.frame.height / 2
        btnCancelAskProduct.clipsToBounds = true
        massageViewContainer.layer.cornerRadius = 15
        messageTextView.layer.cornerRadius = 15
        chatScreenTableView.contentInset.top = 15
        askProductViewContainter.layer.borderWidth = 1.0
        askProductViewContainter.layer.borderColor = UIColor(named: "Primary")?.cgColor
        askProductViewContainter.layer.cornerRadius = 15.0
        imageAskProduct.layer.cornerRadius = 15.0
        askProductViewContainter.isHidden = productAskIsHidden
    }
    
    func configureTableView() {
        chatScreenTableView.delegate = self
        chatScreenTableView.dataSource = self
        chatScreenTableView.register(UINib(nibName: "ChatReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatReceiverTableViewCell")
        chatScreenTableView.register(UINib(nibName: "ChatSenderTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatSenderTableViewCell")
    }
    
    func scrollToBottom() {
        if messageData.isEmpty {
            return
        }
        
        let indexPath = IndexPath(row: messageData.count - 1, section: 0)
        chatScreenTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    @IBAction func sendMessageBtn(_ sender: Any) {
        guard let messageText = messageTextView.text, !messageText.isEmpty else {
            return
        }

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let createdAt = dateFormatter.string(from: currentDate)

        let product: MessageModel.MessageData.MessageProduct?
        if let productId = productAsk?.id, productId != 0 {
            product = MessageModel.MessageData.MessageProduct(
                productId: productId,
                productName: productAsk?.name ?? "",
                price: productAsk.flatMap { Int($0.price) },
                image: ""
            )
        } else {
            product = nil
        }

        let newMessage = MessageModel(
            id: UUID().uuidString,
            data: MessageModel.MessageData(
                createdAt: createdAt,
                isFromUser: true,
                message: messageText,
                userId: userId ?? 0,
                username: "JohnDoe",
                imageProfile: "profile_image_url",
                product: product
            )
        )

        saveMessageToFirebase(message: newMessage)
        messageTextView.text = ""

        if let product = product {
            // Product is not nil, execute additional code
            productAskIsHidden = true
            productAsk = nil
            askProductViewContainter.isHidden = true
        }

        refreshData()
        scrollToBottom()
    }


    
    func observeMessages() {
            messageRef.observe(.childAdded, with: { [weak self] snapshot in
                guard let strongSelf = self,
                      let messageData = snapshot.value as? [String: Any],
                      let data = messageData["data"] as? [String: Any],
                      let userIdFromSnapshot = data["userId"] as? Int,
                      userIdFromSnapshot == strongSelf.userId else {
                    // Skip messages not belonging to the current user
                    return
                }
                
                let id = snapshot.key
                
                let productData = data["product"] as? [String: Any]
                let product = MessageModel.MessageData.MessageProduct(
                    productId: productData?["productId"] as? Int,
                    productName: productData?["productName"] as? String,
                    price: productData?["price"] as? Int,
                    image: productData?["image"] as? String
                )
                
                let message = MessageModel(
                    id: id,
                    data: MessageModel.MessageData(
                        createdAt: data["createdAt"] as? String ?? "",
                        isFromUser: data["isFromUser"] as? Bool ?? false,
                        message: data["message"] as? String ?? "",
                        userId: userIdFromSnapshot,
                        username: data["username"] as? String ?? "",
                        imageProfile: data["imageProfile"] as? String ?? "",
                        product: product
                    )
                )
                
                strongSelf.messageData.append(message)
                strongSelf.refreshData()
                strongSelf.scrollToBottom()
            })
        }
    
    
    func saveMessageToFirebase(message: MessageModel) {
        let messageData: [String: Any] = [
            "id": message.id,
            "data": [
                "createdAt": message.data.createdAt,
                "isFromUser": message.data.isFromUser,
                "message": message.data.message,
                "userId": message.data.userId,
                "username": message.data.username,
                "imageProfile": message.data.imageProfile,
                "product": [
                    "productId": message.data.product?.productId,
                    "productName": message.data.product?.productName,
                    "price": message.data.product?.price,
                    "image": message.data.product?.image
                ]
            ]
        ]
        
        messageRef.child(message.id).setValue(messageData) { (error, _) in
            if let error = error {
                print("Error saving message to Firebase: \(error.localizedDescription)")
            } else {
                print("Message saved successfully to Firebase")
            }
        }
    }
    
    func configureProductView() {
        guard let product = productAsk else { return }
        nameProductAsk.text = product.name
        priceProductAsk.text = "\(product.price)"
        messageTextView.text = messageText
        
        if let imageGalleries = product.galleries, imageGalleries.count > 2 {
            let imageUrl = URL(string: imageGalleries[2].url)
            imageAskProduct.kf.setImage(with: imageUrl)
        } else {
            let defaultImageURL = URL(string: Constants.defaultImageURL)
            imageAskProduct.kf.setImage(with: defaultImageURL)
        }
        
        askProductViewContainter.isHidden = productAskIsHidden
    }
    
    @IBAction func btnCancelAskProductAction(_ sender: Any) {
        productAskIsHidden = true
        productAsk = nil
        askProductViewContainter.isHidden = true
        refreshData()
    }
    
    func refreshData() {
        chatScreenTableView.reloadData()
    }
}

extension ChatScreenViewController: UITableViewDelegate, UITableViewDataSource, ChatSenderCellDelegate {
    func didTapAddToCart(in cell: ChatSenderTableViewCell) {
        let customToast = CustomToast(message: "already saved in the cart", backgroundColor: UIColor(named: "Secondary")!)
        customToast.showToast(duration: 0.5)
    }
    
    func didTapBuyNow(in cell: ChatSenderTableViewCell) {
        let customToast = CustomToast(message: "already saved in the cart", backgroundColor: UIColor(named: "Secondary")!)
        customToast.showToast(duration: 0.5)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMessage = messageData[indexPath.row]
        
        if currentMessage.data.isFromUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSenderTableViewCell", for: indexPath) as! ChatSenderTableViewCell
            
            cell.configure(with: currentMessage)
            cell.delegate = self
            
            if let product = currentMessage.data.product, product.productId != nil {
                cell.containerAskProductIsHidden = false
            } else {
                cell.containerAskProductIsHidden = true
            }
            
            if indexPath.row < messageData.count - 1 {
                let nextMessage = messageData[indexPath.row + 1].data
                if !nextMessage.isFromUser {
                    cell.imageProfileSenderIsHidden = false
                } else {
                    cell.imageProfileSenderIsHidden = true
                }
            } else {
                cell.imageProfileSenderIsHidden = false
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiverTableViewCell", for: indexPath) as! ChatReceiverTableViewCell
            cell.chatMessage.text = currentMessage.data.message
            if indexPath.row < messageData.count - 1 {
                let nextMessage = messageData[indexPath.row + 1].data
                if !nextMessage.isFromUser {
                    cell.imageProfileReceiverIsHidden = true
                } else {
                    cell.imageProfileReceiverIsHidden = false
                }
            } else {
                cell.imageProfileReceiverIsHidden = false
            }
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension ChatScreenViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let maxHeight: CGFloat = messageTextView.font!.lineHeight * 4
        let newHeight = min(newSize.height, maxHeight)
        heightMessageTextView.constant = newHeight
        view.layoutIfNeeded()
    }
}
