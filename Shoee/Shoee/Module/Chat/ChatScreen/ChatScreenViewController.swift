import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatScreenViewController: UIViewController {
    
    @IBOutlet private weak var containerMessage: UIView!
    @IBOutlet private weak var massageViewContainer: UIView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var nameProductAsk: UILabel!
    @IBOutlet private weak var priceProductAsk: UILabel!
    @IBOutlet private weak var chatScreenTableView: UITableView!
    @IBOutlet private weak var heightMessageTextView: NSLayoutConstraint!
    @IBOutlet private weak var messageTextView: UITextView! {
        didSet {
            updateMessageText()
            originalTextViewHeight = heightMessageTextView.constant
        }
    }
    @IBOutlet private weak var imageAskProduct: UIImageView!
    @IBOutlet private weak var btnCancelAskProduct: UIButton!
    @IBOutlet private weak var askProductViewContainter: UIView!
    
    private var originalTextViewHeight: CGFloat = 0.0
    private var initialMessage: String?
    private let userId = UserDefaultManager.getUserID()
    private var messageData: [MessageModel] = []
    var productAsk: ProductModel?
    private var messageText: String = ""
    private let messageRef = Database.database().reference().child("messages")
    var productAskIsHidden: Bool = true
    
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
        observeMessages()
        messageTextView.delegate = self
        setupKeyboardNotifications()
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatScreenViewController.self]
        if let initialMessage = initialMessage {
            messageTextView.text = initialMessage
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 34
    }
    
    private func setupUI() {
        btnCancelAskProduct.applyCircularRadius()
        massageViewContainer.makeCornerRadius(15)
        messageTextView.makeCornerRadius(15)
        imageAskProduct.makeCornerRadius(15)
        askProductViewContainter.setCornerRadiusWith(radius: 15, borderWidth: 1.0, borderColor: Constants.primary!)
        chatScreenTableView.contentInset.top = 15
        askProductViewContainter.isHidden = productAskIsHidden
    }
    
    private func configureUI() {
        configureProductView()
        setupTableView()
    }
    
    
    private func observeMessages() {
        messageRef.observe(.childAdded) { [weak self] snapshot in
            guard let strongSelf = self,
                  let messageData = snapshot.value as? [String: Any],
                  let data = messageData["data"] as? [String: Any],
                  let userIdFromSnapshot = data["userId"] as? Int,
                  userIdFromSnapshot == strongSelf.userId else {
                return
            }
            
            let id = snapshot.key
            let productData = data["product"] as? [String: Any]
            let product = strongSelf.createMessageProduct(from: productData)
            
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
        }
    }
    
    func setInitialMessage(_ message: String) {
        initialMessage = message
    }
    
    private func createMessageProduct(from productData: [String: Any]?) -> MessageModel.MessageData.MessageProduct? {
        guard let productData = productData,
              let productId = productData["productId"] as? Int,
              productId != 0 else {
            return nil
        }
        
        return MessageModel.MessageData.MessageProduct(
            productId: productId,
            productName: productData["productName"] as? String ?? "",
            price: productData["price"] as? Int,
            image: ""
        )
    }
    
    private func configureProductView() {
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
    
    private func setupTableView() {
        chatScreenTableView.delegate = self
        chatScreenTableView.dataSource = self
        
        ChatScreen.allCases.forEach { cell in
            chatScreenTableView.registerCellWithNib(cell.cellTypes)
        }
    }
    
    
    private func scrollToBottom() {
        guard !messageData.isEmpty else { return }
        
        let indexPath = IndexPath(row: messageData.count - 1, section: 0)
        chatScreenTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    private func updateMessageText() {
        messageText = messageTextView.text
    }
    
    @IBAction private func btnCancelAskProductAction(_ sender: Any) {
        productAskIsHidden = true
        productAsk = nil
        askProductViewContainter.isHidden = true
        refreshData()
    }
    
    @IBAction private func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction private func sendMessageBtn(_ sender: Any) {
        guard let messageText = messageTextView.text, !messageText.isEmpty else { return }
        
        let id = generateCustomID()
        let createdAt = getCurrentDateString()
        let product = createProductModel()
        
        let newMessage = MessageModel(
            id: id,
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
        heightMessageTextView.constant = originalTextViewHeight
        
        if product != nil {
            productAskIsHidden = true
            productAsk = nil
            askProductViewContainter.isHidden = true
        }
        
        refreshData()
        scrollToBottom()
    }
    
    private func generateCustomID() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.string(from: currentDate)
    }
    
    private func getCurrentDateString() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.formatDate
        return dateFormatter.string(from: currentDate)
    }
    
    private func clearMessageInput() {
        messageTextView.text = ""
    }
    
    private func createProductModel() -> MessageModel.MessageData.MessageProduct? {
        guard let productId = productAsk?.id, productId != 0 else { return nil }
        
        return MessageModel.MessageData.MessageProduct(
            productId: productId,
            productName: productAsk?.name ?? "",
            price: productAsk.flatMap { Int($0.price) },
            image: ""
        )
    }
    
    private func saveMessageToFirebase(message: MessageModel) {
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
                    "productId": message.data.product?.productId ?? "",
                    "productName": message.data.product?.productName ?? "",
                    "price": message.data.product?.price ?? "",
                    "image": message.data.product?.image ?? ""
                ]
            ]
        ]
        
        messageRef.child(message.id).setValue(messageData)
    }
    
    
    private func refreshData() {
        chatScreenTableView.reloadData()
    }
    
}

extension ChatScreenViewController: UITableViewDelegate, UITableViewDataSource, ChatSenderCellDelegate {
    func didTapAddToCart(in cell: ChatSenderTableViewCell) {
        showToast(message: "Already saved in the cart", backgroundColor: Constants.secondary!)
    }
    
    func didTapBuyNow(in cell: ChatSenderTableViewCell) {
        showToast(message: "Already saved in the cart", backgroundColor: Constants.secondary!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMessage = messageData[indexPath.row]
        
        if currentMessage.data.isFromUser {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ChatSenderTableViewCell
            cell.configure(with: currentMessage)
            cell.delegate = self
            
            if let product = currentMessage.data.product, product.productId != nil {
                cell.containerAskProductIsHidden = false
            } else {
                cell.containerAskProductIsHidden = true
            }
            
            if indexPath.row < messageData.count - 1 {
                let nextMessage = messageData[indexPath.row + 1].data
                cell.imageProfileSenderIsHidden = !nextMessage.isFromUser
            } else {
                cell.imageProfileSenderIsHidden = false
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ChatReceiverTableViewCell
            
            cell.chatMessage.text = currentMessage.data.message
            
            if indexPath.row < messageData.count - 1 {
                let nextMessage = messageData[indexPath.row + 1].data
                cell.imageProfileReceiverIsHidden = nextMessage.isFromUser
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
        updateMessageText()
        
        let maxHeight: CGFloat = 4.0 * textView.font!.lineHeight
        
        let expectedHeight = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        
        heightMessageTextView.constant = min(expectedHeight, maxHeight)
        scrollToBottom()
    }
    
    private func showToast(message: String, backgroundColor: UIColor) {
        let customToast = CustomToast(message: message, backgroundColor: backgroundColor)
        customToast.showToast(duration: 0.5)
    }
}


