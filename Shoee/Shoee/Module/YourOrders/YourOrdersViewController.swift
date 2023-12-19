import UIKit

class YourOrdersViewController: UIViewController {

    @IBOutlet weak var yourOrdersTableView: UITableView!

    var transactionData: [TransactionModel] = []
    var paymentGateData: [BCAResponse] = []

    private let refreshControl = UIRefreshControl()
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        yourOrdersTableView.delegate = self
        yourOrdersTableView.dataSource = self

        yourOrdersTableView.register(UINib(nibName: "YourOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "YourOrdersTableViewCell")

        yourOrdersTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        transactionOnMyApiStatus()
    }

    @objc private func refreshData() {
        fetchPaymentGateData()
    }

    func transactionOnMyApiStatus() {
        APIManager.shared.makeAPICall(endpoint: .transactions) { [weak self] (result: Result<TransactionResponse, Error>) in
            switch result {
            case .success(let result):
                self?.transactionData = result.data.data
               
                if !result.data.data.isEmpty {
                    self?.fetchPaymentGateData()
                }

            case .failure(let error):
                print("API Error: \(error)")
                
            }
        }
    }


    func fetchPaymentGateData() {
        paymentGateData.removeAll()

        fetchTransactionStatus(forIndex: transactionData.count - 1)
    }

    func fetchTransactionStatus(forIndex index: Int) {
        guard index >= 0 else {
            
            yourOrdersTableView.reloadData()
            refreshControl.endRefreshing()
            return
        }

        let transaction = transactionData[index]

        transactionStatus(with: transaction.paymentId) { [weak self] in
            
            self?.fetchTransactionStatus(forIndex: index - 1)
        }
    }
    
    func transactionStatus(with paymentID: String, completion: @escaping () -> Void) {
        APIManagerPaymentGateWay.shared.makeAPICall(endpoint: .transactionStatus(paymentID: paymentID)) { [weak self] (result: Result<BCAResponse, Error>) in
            switch result {
            case .success(let bcaResponse):
                if let bcaResponse = bcaResponse as? BCAResponse {
                    self?.paymentGateData.append(bcaResponse)
                } else {
                    print("Error: Invalid response structure")
                }

            case .failure(let error):
                print("API Error: \(error)")
            }

            // Call the completion handler when the transaction status request is complete
            completion()
        }
    }


}

extension YourOrdersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentGateData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourOrdersTableViewCell", for: indexPath) as! YourOrdersTableViewCell

        let paymentGate = paymentGateData[indexPath.row]
        let bank = paymentGate.vaNumbers?.first?.bank
        cell.configure(total: "$\((paymentGate.grossAmount) ?? "")", status: paymentGate.transactionStatus ?? "", image:  "ic_\((bank) ?? "")")

        return cell
    }
}
