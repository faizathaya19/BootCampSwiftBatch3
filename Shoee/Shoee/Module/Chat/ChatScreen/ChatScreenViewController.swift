import UIKit

class ChatScreenViewController: UIViewController {
    @IBOutlet weak var massageViewContainer: UIView!
    @IBOutlet weak var chatScreenTableView: UITableView!
    @IBOutlet weak var heightMessageTextView: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    
    var messageData: [MessageModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        chatScreenTableView.delegate = self
        chatScreenTableView.dataSource = self
        chatScreenTableView.register(UINib(nibName: "ChatReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatReceiverTableViewCell")
        chatScreenTableView.register(UINib(nibName: "ChatSenderTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatSenderTableViewCell")
        massageViewContainer.layer.cornerRadius = 15
        messageTextView.layer.cornerRadius = 15
        chatScreenTableView.contentInset.top = 15
        messageTextView.delegate = self
        heightMessageTextView.constant = calculateInitialTextViewHeight()
    }

    private func calculateInitialTextViewHeight() -> CGFloat {
        let initialNumberOfLines: CGFloat = 1
        return messageTextView.font!.lineHeight * initialNumberOfLines
    }

    private func scrollToBottom() {
        let indexPath = IndexPath(row: messageData.count - 1, section: 0)
        chatScreenTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    private func addNewMessage(_ message: MessageModel) {
        messageData.append(message)
        chatScreenTableView.reloadData()
        scrollToBottom()
    }
}

extension ChatScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageData = messageData[indexPath.row]

        if messageData.data.isFromUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSenderTableViewCell", for: indexPath) as! ChatSenderTableViewCell
            cell.chatMessage.text = messageData.data.message
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiverTableViewCell", for: indexPath) as! ChatReceiverTableViewCell
            cell.chatMessage.text = messageData.data.message
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

        let bottomOffset = CGPoint(x: 0, y: max(0, newSize.height - textView.bounds.size.height))
        textView.setContentOffset(bottomOffset, animated: false)

        view.layoutIfNeeded()
    }
}
