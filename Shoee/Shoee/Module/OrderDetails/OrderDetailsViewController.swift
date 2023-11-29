import UIKit



class OrderDetailsViewController: UIViewController {
    
     @IBOutlet weak var orderDetailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orderDetailsTableView.delegate = self
        orderDetailsTableView.dataSource = self

        // Register the cell nibs
        orderDetailsTableView.register(UINib(nibName: "StatusOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "statusOrderTableViewCell")
        orderDetailsTableView.register(UINib(nibName: "ListOrderDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "listOrderDetailTableViewCell")
        orderDetailsTableView.register(UINib(nibName: "OtherOrderDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "otherOrderDetailTableViewCell")
    }

}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
     
            return 3
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusOrderTableViewCell", for: indexPath) as! StatusOrderTableViewCell
            tableView.contentInset.top = 20
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "listOrderDetailTableViewCell", for: indexPath) as! ListOrderDetailTableViewCell
           
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherOrderDetailTableViewCell", for: indexPath) as! OtherOrderDetailTableViewCell
            return cell
        default:
            fatalError("Unexpected section")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
            switch indexPath.section {
            case 0:
                return 102.0
            case 1:
                return 130.0
            case 2:
                return 585.0
            default:
                return UITableView.automaticDimension
            }
        
    }
}
