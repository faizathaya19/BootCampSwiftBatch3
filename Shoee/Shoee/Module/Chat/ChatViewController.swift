import UIKit

struct MessageModel {
    let id: String
    let data: MessageData
    
    struct MessageData {
        let createdAt: String
        let isFromUser: Bool
        let message: String
        let userId: Int
        let username: String
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
    private let userId = 13
    private var refreshTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefreshTimer()
        fetchMessage()
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
        fetchMessage()
        chatTableView.reloadData()
    }
    
    func fetchMessage() {
        let allMessages = [
            MessageModel(id: "test123",
                         data: MessageModel.MessageData(
                            createdAt: "2023-12-13 15:30:00.987876",
                            isFromUser: true,
                            message: "ngomong apaan si anjg kontollllllllllllllll",
                            userId: 13,
                            username: "faiz Athaya Ramadhan",
                            product: MessageModel.MessageData.MessageProduct(
                                productId: 1,
                                productName: "futsal",
                                price: 399,
                                image: ""
                            )
                         )
                        ),
            MessageModel(id: "test456",
                         data: MessageModel.MessageData(
                            createdAt: "2023-12-13 08:04:16.987876",
                            isFromUser: true,
                            message: "testing",
                            userId: 14,
                            username: "faiz Athaya Ramadhan",
                            product: nil
                         )
                        ),
            MessageModel(id: "test7891",
                         data: MessageModel.MessageData(
                            createdAt: "2023-12-13 07:04:16.987876",
                            isFromUser: false,
                            message: "testing",
                            userId: 13,
                            username: "faiz Athaya Ramadhan",
                            product: MessageModel.MessageData.MessageProduct(
                                productId: 1,
                                productName: "futsal",
                                price: 399,
                                image: ""
                            )
                         )
                        ),
            MessageModel(id: "test78912",
                         data: MessageModel.MessageData(
                            createdAt: "2023-12-13 07:04:16.987876",
                            isFromUser: true,
                            message: "testing",
                            userId: 13,
                            username: "faiz Athaya Ramadhan",
                            product: MessageModel.MessageData.MessageProduct(
                                productId: 1,
                                productName: "futsal",
                                price: 399,
                                image: ""
                            )
                         )
                        ),
            MessageModel(id: "test789",
                         data: MessageModel.MessageData(
                            createdAt: "2023-12-13 07:04:16.987876",
                            isFromUser: true,
                            message: "testing",
                            userId: 13,
                            username: "faiz Athaya Ramadhan",
                            product: MessageModel.MessageData.MessageProduct(
                                productId: 1,
                                productName: "futsal",
                                price: 399,
                                image: ""
                            )
                         )
                        ),
            MessageModel(id: "test789asd",
                         data: MessageModel.MessageData(
                            createdAt: "2023-12-13 07:04:16.987876",
                            isFromUser: true,
                            message: "testing",
                            userId: 13,
                            username: "faiz Athaya Ramadhan",
                            product: MessageModel.MessageData.MessageProduct(
                                productId: 1,
                                productName: "futsal",
                                price: 399,
                                image: ""
                            )
                         )
                        ),
            MessageModel(id: "test789qw",
                                        data: MessageModel.MessageData(
                                           createdAt: "2023-12-13 07:04:16.987876",
                                           isFromUser: false,
                                           message: "testing",
                                           userId: 13,
                                           username: "faiz Athaya Ramadhan",
                                           product: MessageModel.MessageData.MessageProduct(
                                               productId: 1,
                                               productName: "futsal",
                                               price: 399,
                                               image: ""
                                           )
                                        )
                                       )
        ]
        
        messageData = allMessages.filter { $0.data.userId == userId }
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
            ChatScreenViewController.messageData = messageData
            ChatScreenViewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(ChatScreenViewController, animated: true)
        }
    }
}
