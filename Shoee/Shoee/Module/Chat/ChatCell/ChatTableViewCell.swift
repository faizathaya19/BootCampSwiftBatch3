import UIKit

class ChatTableViewCell: BaseTableCell {

    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var textForActive: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with message: MessageModel) {
        messageText.text = message.data.message
        textForActive.text = elapsedTimeString(from: message.data.createdAt)
    }

    private func elapsedTimeString(from createdAt: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let createdDate = dateFormatter.date(from: createdAt) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear], from: createdDate, to: Date())

            if components.minute == 0 {
                return "Now"
            } else if components.day == 0 {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                return formatter.string(from: createdDate)
            } else if components.day == 1 {
                return "Yesterday"
            } else if components.weekOfYear! < 1 {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE"
                return formatter.string(from: createdDate)
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yy"
                return formatter.string(from: createdDate)
            }
        }

        return "Unknown"
    }

}
