import UIKit

class PaymentProcessViewController: UIViewController {


    @IBOutlet weak var paymentProcessTableVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentProcessTableVIew.delegate = self
        paymentProcessTableVIew.dataSource = self

        // Register the cell nibs
        paymentProcessTableVIew.register(UINib(nibName: "ExpiredTimerPaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "expiredTimerPaymentTableViewCell")
        paymentProcessTableVIew.register(UINib(nibName: "AccoountVATableViewCell", bundle: nil), forCellReuseIdentifier: "accoountVATableViewCell")
       
    }
    
   
}




extension PaymentProcessViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
       
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
                let createdOnString = "29 Nov 2023, 14:30"
                let cell = tableView.dequeueReusableCell(withIdentifier: "expiredTimerPaymentTableViewCell", for: indexPath) as! ExpiredTimerPaymentTableViewCell
            cell.configureCell(createdOnString: createdOnString, expirytime: createdOnString)
                tableView.contentInset.top = 100
                return cell
            // Handle other cases as needed
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "accoountVATableViewCell", for: indexPath) as! AccoountVATableViewCell
            
            return cell
       
        default:
            fatalError("Unexpected section")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 73.0
        case 1:
            return 420.0
        
        default:
            return UITableView.automaticDimension
        }
        
    }
}
