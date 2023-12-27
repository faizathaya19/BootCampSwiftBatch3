import UIKit

enum OrderDetails: Int, CaseIterable {
    case statusOrder
    case listOrder
    case otherOrder
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .statusOrder:
            return StatusOrderTableViewCell.self
        case .listOrder:
            return ListitemsTableViewCell.self
        case .otherOrder:
            return OtherOrderDetailTableViewCell.self
        }
    }
}

class OrderDetailsViewController: UIViewController {
    
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var orderDetailsTableView: UITableView!
    
    var transactionData: [TransactionModel] = []
    var paymentGateData: BCAResponse?
    
    var filteredDataTransaction: [TransactionModel] = []
    
    var paymentID: String = ""
    
    init(paymentID: String) {
        super.init(nibName: nil, bundle: nil)
        self.paymentID = paymentID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        configure(status: (paymentGateData?.transactionStatus) ?? "")
        filterTransaction()
    }
    
    private func registerCells() {
        orderDetailsTableView.delegate = self
        orderDetailsTableView.dataSource = self
        
        OrderDetails.allCases.forEach { cell in
            orderDetailsTableView.registerCellWithNib(cell.cellTypes)
        }
        
    }
    
    func configure(status: String) {
        if status.lowercased() == "settlement" {
            labelHeader.text = "Checkout Success"
        } else if status.lowercased() == "pending" {
            labelHeader.text = "Checkout Pending"
        }  else if status.lowercased() == "expire" {
            labelHeader.text = "Checkout Expired"
        } else {
            labelHeader.text = status
        }
    }
    
    func filterTransaction() {
        filteredDataTransaction = transactionData.filter { $0.paymentId == paymentID }
    }
    
}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return OrderDetails.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let orderDetailsSection = OrderDetails(rawValue: section)
        switch orderDetailsSection {
        case .listOrder:
            return filteredDataTransaction.flatMap { $0.items }.count
        case .statusOrder, .otherOrder:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderDetailsSection = OrderDetails(rawValue: indexPath.section)
        switch orderDetailsSection {
        case .statusOrder:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as StatusOrderTableViewCell
            
            cell.configure(status: paymentGateData?.transactionStatus ?? "", date: paymentGateData?.transactionTime ?? "")
            return cell
        case .listOrder:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ListitemsTableViewCell
            
            let transaction = filteredDataTransaction.flatMap { $0.items }[indexPath.row]
            
            let thirdGalleryURL = transaction.product.galleries?.dropFirst(3).first?.url
            
            cell.configure(withQuantity: transaction.quantity, price: transaction.product.price, productName: transaction.product.name, imageURL: thirdGalleryURL ?? Constants.defaultImageURL)
            
            
            return cell
        case .otherOrder:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as OtherOrderDetailTableViewCell
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
