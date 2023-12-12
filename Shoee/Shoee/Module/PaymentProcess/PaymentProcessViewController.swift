import UIKit

// MARK: - Payment Process Section Enum

enum PaymentProcessSection: Int, CaseIterable {
    case expiredPayment
    case accountVA
    case cancelPayment
    
    var cellType: UITableViewCell.Type {
        switch self {
        case .expiredPayment:
            return ExpiredTimerPaymentTableViewCell.self
        case .accountVA:
            return AccoountVATableViewCell.self
        case .cancelPayment:
            return CencelPaymentTableViewCell.self
        }
    }
}

// MARK: - Payment Process View Controller

class PaymentProcessViewController: UIViewController {
    
    @IBOutlet private weak var paymentProcessTableVIew: UITableView!
    
    var paymentID: String = ""
    var paymentBCA: BCAResponse?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    init(paymentID: String) {
        super.init(nibName: nil, bundle: nil)
        self.paymentID = paymentID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidesBottomBarWhenPushed = true
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        paymentProcessTableVIew.delegate = self
        paymentProcessTableVIew.dataSource = self
        
        PaymentProcessSection.allCases.forEach { section in
            paymentProcessTableVIew.registerCellWithNib(section.cellType)
        }
    }
}

// MARK: - Extensions

extension PaymentProcessViewController: UITableViewDelegate, UITableViewDataSource, CencelPaymentCellDelegate, AccoountVACellDelegate {
    
    func goToOrderDetails(inCell cell: AccoountVATableViewCell) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToHome(inCell cell: AccoountVATableViewCell) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func cencelPaymentBtn(inCell cell: CencelPaymentTableViewCell) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PaymentProcessSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let paymentProcessSection = PaymentProcessSection(rawValue: section) else { return 0 }
        
        switch paymentProcessSection {
        case .expiredPayment, .accountVA, .cancelPayment:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let paymentProcessSection = PaymentProcessSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch paymentProcessSection {
        case .expiredPayment:
            guard let expiryTime = paymentBCA?.expiryTime, let createdOn = paymentBCA?.transactionTime else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ExpiredTimerPaymentTableViewCell
            cell.configureCell(transactionTime: createdOn, expiryTimeValue: expiryTime)
            return cell
            
        case .accountVA:
            guard let totalPayment = paymentBCA?.grossAmount,
                  let bank = paymentBCA?.vaNumbers.first?.bank,
                  let numberVA = paymentBCA?.vaNumbers.first?.vaNumber else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AccoountVATableViewCell
            cell.delegate = self
            cell.configure(totalPayment: "$\(totalPayment)", numberVA: numberVA, bankImageName: "ic_\(bank)")
            return cell
            
        case .cancelPayment:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CencelPaymentTableViewCell
            cell.delegate = self
            tableView.contentInset.top = 100
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let paymentProcessSection = PaymentProcessSection(rawValue: indexPath.section) else { return UITableView.automaticDimension }
        
        switch paymentProcessSection {
        case .expiredPayment:
            return 73.0
        case .accountVA:
            return 420.0
        case .cancelPayment:
            return 56.0
        }
    }
}
