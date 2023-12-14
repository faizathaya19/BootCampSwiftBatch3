import UIKit
import Firebase

struct MessageModel {
    let id: String
    let data: MessageData
    
    struct MessageData {
        let createdAt: String
        let isFromUser: Bool
        let message: String
        let userId: Int
        let username: String
        let imageProfile: String
        let product: MessageProduct?
        
        struct MessageProduct {
            let productId: Int?
            let productName: String?
            let price: Int?
            let image: String?
        }
    }
}

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    private var messageData: [MessageModel] = []
    private let userId = UserDefaultManager.getUserID()
    private var refreshTimer: Timer?
    
    let messageRef = Database.database().reference().child("messages")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefreshTimer()
    }
    
    deinit {
        refreshTimer?.invalidate()
    }
    
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyTableViewCell")
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        chatTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(timeInterval: 00.1, target: self, selector: #selector(updateChat), userInfo: nil, repeats: true)
        refreshTimer?.tolerance = 0.1
    }
    
    @objc private func updateChat() {
        observeMessages()
//        fetchMessage()
        chatTableView.reloadData()
    }
    
//    func fetchMessage() {
//        let allMessages = [MessageModel]
//
//        messageData = allMessages.filter { $0.data.userId == userId } .reversed()
//    }
    
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

            // Check if the message is newer than existing messages
            if let existingMessage = strongSelf.messageData.first, message.data.createdAt > existingMessage.data.createdAt {
                strongSelf.messageData.insert(message, at: 0)
            } else {
                strongSelf.messageData.append(message)
            }

            strongSelf.chatTableView.reloadData()
        })
    }

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource, EmptyCellDelegate {
    
    func btnAction(inCell cell: EmptyTableViewCell) {
        if let tabBarController = self.tabBarController,
           let navigationController = tabBarController.selectedViewController as? UINavigationController {
            tabBarController.selectedIndex = 0
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.isEmpty ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messageData.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.configure(withImageNamed: "ic_headset_nil", message: "You have never done a transaction", title: "Opss no message yet?")
            cell.delegate = self
            tableView.isScrollEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            let latestMessage = messageData.first!
            cell.configure(with: latestMessage)
            chatTableView.contentInset.top = 15
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return messageData.isEmpty ? 728 : 94.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !messageData.isEmpty else {
            return
        }
        
        if let navigationController = self.navigationController {
            let ChatScreenViewController = ChatScreenViewController()
            ChatScreenViewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(ChatScreenViewController, animated: true)
        }
    }
}
