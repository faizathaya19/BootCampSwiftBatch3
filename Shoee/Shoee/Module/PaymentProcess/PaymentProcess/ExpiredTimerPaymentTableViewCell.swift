import UIKit

class ExpiredTimerPaymentTableViewCell: BaseTableCell {

    @IBOutlet weak var expiryTime: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var containerViewExp: UIView!
    
    var timer: Timer?
    var expiryDate: Date?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerViewExp.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(createdOnString: String , expirytime:String) {
        expiryTime.text = expirytime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        let createdOnDate = dateFormatter.date(from: createdOnString)!

        expiryDate = calculateExpiryDate(createdOnDate: createdOnDate)
        updateTimerLabel()
        startTimer()
    }
    
    func calculateExpiryDate(createdOnDate: Date) -> Date {
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
        
        if timeDifference <= 0 {
            // Timer expired
            timerLabel.text = "Expired"
            timer?.invalidate()
        } else {
            let hours = Int(timeDifference) / 3600
            let minutes = Int(timeDifference) / 60 % 60
            let seconds = Int(timeDifference) % 60
            
            // Format the time components as "jam : menit : detik"
            timerLabel.text = String(format: "%02d : %02d : %02d", hours, minutes, seconds)
        }
    }

    
    deinit {
        timer?.invalidate()
    }
}
