import UIKit
import SkeletonView

enum YourOrder: Int, CaseIterable {
    case empty
    case filter
    case yourOrder
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .empty:
            return EmptyTableViewCell.self
        case .filter:
            return FilterTableViewCell.self
        case .yourOrder:
            return YourOrdersTableViewCell.self
        }
    }
}

class YourOrdersViewController: UIViewController {
    
    @IBOutlet private weak var yourOrdersTableView: UITableView!
    
    private var transactionData: [TransactionModel] = []
    private var paymentGateData: [BCAResponse] = []
    private lazy var popUpLoading = PopUpLoading(on: view)
    
    private var filterOnOff: Bool = false
    private var selectedFilter: String?
    
    private let refreshControl = UIRefreshControl()
    
    @IBAction func backBtn(_ sender: Any) {
           self.popUpLoading.dismissAfter1()
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
            
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
       }
    
    @IBAction func filterOnOff(_ sender: Any) {
          filterOnOff.toggle()
          yourOrdersTableView.reloadData()
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
        setupSkeletonView()
        popUpLoading.showInFull()
        fetchData()
    }

    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        yourOrdersTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func registerCells() {
        yourOrdersTableView.delegate = self
        yourOrdersTableView.dataSource = self
        
        YourOrder.allCases.forEach { cell in
            yourOrdersTableView.registerCellWithNib(cell.cellTypes)
        }
    }
    
    private func setupSkeletonView() {
        yourOrdersTableView.showAnimatedGradientSkeleton(usingGradient: Constants.skeletonColor)
    }
    
    private func fetchData() {
        transactionOnMyApiStatus()
    }
    
    @objc private func refreshData() {
        transactionOnMyApiStatus()
    }
    
    private func transactionOnMyApiStatus() {
        APIManager.shared.makeAPICall(endpoint: .transactions) { [weak self] (result: Result<TransactionResponse, Error>) in
            switch result {
            case .success(let result):
                self?.transactionData = result.data.data.reversed()
                if result.data.data.isEmpty {
                    self?.popUpLoading.dismissAfter1()
                    self?.yourOrdersTableView.hideSkeleton()
                    self?.refreshControl.endRefreshing()
                }
                if !result.data.data.isEmpty {
                    self?.fetchPaymentGateData()
                }
                
            case .failure(_):
             break
            }
        }
    }
    
    private func fetchPaymentGateData() {
        let sortedTransactionData = transactionData.sorted { $0.paymentId > $1.paymentId }
        paymentGateData.removeAll()
        fetchTransactionStatus(forSortedData: sortedTransactionData, index: 0)
    }

    private func fetchTransactionStatus(forSortedData sortedData: [TransactionModel], index: Int) {
        guard index < sortedData.count else {
            yourOrdersTableView.reloadData()
            refreshControl.endRefreshing()
            return
        }
        
        let transaction = sortedData[index]
        
        if paymentGateData.indices.contains(index), paymentGateData[index] == nil {
            transactionStatus(with: transaction.paymentId) { [weak self] in
                self?.fetchTransactionStatus(forSortedData: sortedData, index: index)
            }
        } else {
            if transaction.paymentId != nil {
                transactionStatus(with: transaction.paymentId) { [weak self] in
                    self?.fetchTransactionStatus(forSortedData: sortedData, index: index + 1)
                }
            } else {
                fetchTransactionStatus(forSortedData: sortedData, index: index + 1)
            }
        }
    }

    private func transactionStatus(with paymentID: String, completion: @escaping () -> Void) {
        APIManagerPaymentGateWay.shared.makeAPICall(endpoint: .transactionStatus(paymentID: paymentID)) { [weak self] (result: Result<BCAResponse, Error>) in
            switch result {
            case .success(let bcaResponse):
                if let bcaResponse = bcaResponse as? BCAResponse {
                    self?.paymentGateData.append(bcaResponse)
                    self?.popUpLoading.dismissAfter1()
                    self?.yourOrdersTableView.hideSkeleton()
                } else {
                    self?.popUpLoading.dismissAfter1()
                    self?.yourOrdersTableView.hideSkeleton()
                }
                
            case .failure(_):
                break
            }
            
            completion()
        }
    }
}

extension YourOrdersViewController: UITableViewDelegate, UITableViewDataSource, EmptyCellDelegate {
    func btnAction(inCell cell: EmptyTableViewCell) {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return YourOrder.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let yourOrderSection = YourOrder(rawValue: section) else {
            return 0
        }

        if transactionData.isEmpty {
            switch yourOrderSection {
            case .empty:
                return 1
            default:
                return 0
            }
        } else {
            switch yourOrderSection {
            case .empty:
                return 0
            case .filter:
                return filterOnOff ? 1 : 0
            case .yourOrder:
                if let selectedFilter = selectedFilter, !selectedFilter.isEmpty {
                    let filteredData = paymentGateData.filter { $0.transactionStatus == selectedFilter }
                    return filteredData.count
                } else {
                    return paymentGateData.count
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let yourOrderSection = YourOrder(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch yourOrderSection {
        case .empty:
            if transactionData.isEmpty {
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as EmptyTableViewCell
                cell.configure(withImageNamed: "ic_cart_nil", message: "You have never done a transaction", title: "Opss! Your Order is Empty")
                cell.delegate = self
                tableView.isScrollEnabled = false
                tableView.frame.size.height = 729.0
                return cell
            } else {
                break
            }

        case .filter:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilterTableViewCell
            cell.delegate = self
            return cell

        case .yourOrder:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as YourOrdersTableViewCell
            let filteredData: [BCAResponse]
            
            if let selectedFilter = selectedFilter, !selectedFilter.isEmpty {
                filteredData = paymentGateData.filter { $0.transactionStatus == selectedFilter }
            } else {
                filteredData = paymentGateData
            }
            
            guard indexPath.row < filteredData.count && indexPath.row < transactionData.count else {
                return cell
            }
            
            let paymentGate = filteredData[indexPath.row]
            let transaction = transactionData[indexPath.row]
    
            guard
                let bankImageName = paymentGate.vaNumbers?.first?.bank ?? paymentGate.paymentType,
                let statusTransaction = paymentGate.transactionStatus,
                let grossAmount = paymentGate.grossAmount,
                let transactionTime = paymentGate.transactionTime
            else {
                return UITableViewCell()
            }

            cell.configure(total: "$\(grossAmount)", status: statusTransaction, name: transaction.payment, image: "ic_\(bankImageName)", date: transactionTime)

            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let yourOrderSection = YourOrder(rawValue: indexPath.section) else {
            return
        }
        
        switch yourOrderSection {
        case .filter:
            break
        case .yourOrder:
            var filteredDataPaymentGate: [BCAResponse]
            if let selectedFilter = selectedFilter, !selectedFilter.isEmpty {
                filteredDataPaymentGate = paymentGateData.filter { $0.transactionStatus == selectedFilter }
            } else {
                filteredDataPaymentGate = paymentGateData
            }
            
            guard indexPath.row < filteredDataPaymentGate.count else {
                return
            }
            
            let paymentGateFiltered = filteredDataPaymentGate[indexPath.row]
            
            guard let transactionStatus = paymentGateFiltered.transactionStatus else {
                break
            }
            
            if transactionStatus == "pending" {
                navigateToPaymentProcess(paymentGateFiltered: paymentGateFiltered)
            } else {
                navigateToOrderDetails(paymentGateFiltered: paymentGateFiltered)
            }
        default:
               break
        }
    }
    
    private func navigateToPaymentProcess(paymentGateFiltered: BCAResponse) {
        let vC = PaymentProcessViewController(paymentID: paymentGateFiltered.orderId ?? "")
        vC.paymentBCA = paymentGateFiltered
        self.navigationController?.pushViewController(vC, animated: true)
    }

    private func navigateToOrderDetails(paymentGateFiltered: BCAResponse) {
        let vC = OrderDetailsViewController(paymentID: paymentGateFiltered.orderId ?? "")
        vC.transactionData = transactionData
        vC.paymentGateData = paymentGateFiltered
        self.navigationController?.pushViewController(vC, animated: true)
    }

}

extension YourOrdersViewController: FillterCollectionViewCellDelegate {
    func didSelectFilterOption(_ option: String, isFilterOn: Bool) {
        selectedFilter = isFilterOn ? option : nil
        yourOrdersTableView.reloadData()
    }
}

extension YourOrdersViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return YourOrder.allCases.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let yourOrderSection = YourOrder(rawValue: indexPath.section)
        
        switch yourOrderSection {
        case .filter:
            return String(describing: FilterTableViewCell.self)
        case .yourOrder:
            return String(describing: YourOrdersTableViewCell.self)
        default:
            return ""
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let yourOrderSection = YourOrder(rawValue: section) else {
            return 1
        }
        
        switch yourOrderSection {
        case .filter:
            return 0
        case .yourOrder:
            return 6
        default:
            return 0
        }
    }
}
