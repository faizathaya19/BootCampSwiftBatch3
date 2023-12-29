import UIKit

class ExpiredTimerPaymentTableViewCell: BaseTableCell {

    @IBOutlet weak var expiryTime: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var containerViewExp: UIView!
    
    var timer: Timer?
    var expiryDate: Date?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerViewExp.makeCornerRadius(15)
    }
    
    func configureCell(transactionTime: String, expiryTimeValue: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.formatDate

        guard let transactionDate = dateFormatter.date(from: transactionTime),
              let expiryDateValue = dateFormatter.date(from: expiryTimeValue) else {
            return
        }

        expiryTime.text = expiryTimeValue

        expiryDate = calculateExpiryDate(createdOnDate: transactionDate, expiryDateValue: expiryDateValue)
        updateTimerLabel()
        startTimer()
    }

    func calculateExpiryDate(createdOnDate: Date, expiryDateValue: Date) -> Date {
        return Calendar.current.date(byAdding: .hour, value: 24, to: createdOnDate)!
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }

    @objc func updateTimerLabel() {
        guard let expiryDate = expiryDate else {
            return
        }

        let currentDate = Date()
        let timeDifference = expiryDate.timeIntervalSince(currentDate)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.formatDate

        if timeDifference <= 0 {
     
            timerLabel.text = "Expired"
            expiryTime.text = "Expired"
            timer?.invalidate()
        } else {
            let hours = Int(timeDifference) / 3600
            let minutes = Int(timeDifference) / 60 % 60
            let seconds = Int(timeDifference) % 60

            timerLabel.text = String(format: "%02d : %02d : %02d", hours, minutes, seconds)
        }
    }

    deinit {
        timer?.invalidate()
    }
}
