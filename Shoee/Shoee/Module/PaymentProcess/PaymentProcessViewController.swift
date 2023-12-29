import UIKit
import Lottie

enum PaymentProcessSection: Int, CaseIterable {
    case expiredPayment
    case accountVA
    case cancelPayment
    case empty
    
    var cellType: UITableViewCell.Type {
        switch self {
        case .expiredPayment:
            return ExpiredTimerPaymentTableViewCell.self
        case .accountVA:
            return AccoountVATableViewCell.self
        case .cancelPayment:
            return CencelPaymentTableViewCell.self
        case .empty:
            return EmptyTableViewCell.self
        }
    }
}

class PaymentProcessViewController: UIViewController {
    
    @IBOutlet weak var container2PaymentSuccess: UIView!
    @IBOutlet weak var containerAnimationPaymentSuccess: UIView!
    @IBOutlet weak var animationPaymentSuccess: UIView!
    @IBOutlet private weak var paymentProcessTableVIew: UITableView!
    
    lazy var popUpLoading = PopUpLoading(on: view)
    var paymentID: String = ""
    var paymentBCA: BCAResponse?
    
    private var refreshTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupAnimationView()
        containerAnimationPaymentSuccess.isHidden = true
        container2PaymentSuccess.makeCornerRadius(15)
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
        
        transactionStatus(with: paymentID)
        
        refreshTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(autoRefresh), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: Constants.paymentSuccessLottie)
        view.loopMode = .playOnce
        view.animationSpeed = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupAnimationView() {
        animationPaymentSuccess.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: animationPaymentSuccess.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: animationPaymentSuccess.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: animationPaymentSuccess.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: animationPaymentSuccess.heightAnchor)
        ])
    }
    
    @objc private func autoRefresh() {
        transactionStatus(with: paymentID)
    }
    
    func transactionStatus(with paymentID: String) {
        APIManagerPaymentGateWay.shared.makeAPICall(endpoint: .transactionStatus(paymentID: paymentID)) { [self] (result: Result<BCAResponse, Error>) in
            
            switch result {
            case .success(let bcaResponse):
                
                self.paymentBCA = bcaResponse
                self.paymentProcessTableVIew.reloadData()
                
                if bcaResponse.transactionStatus == "settlement" {
                    
                    self.containerAnimationPaymentSuccess.isHidden = false
                    self.animationView.play()
                    animationView.loopMode = .loop
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.containerAnimationPaymentSuccess.isHidden = true
                        let navigationController = UINavigationController(rootViewController: CustomMainTabBar())
                        UIApplication.shared.keyWindow?.rootViewController = navigationController
                    }
                    
                    self.refreshTimer?.invalidate()
                    self.refreshTimer = nil
                }
                
            case .failure(_):
                break
            }
        }
    }
    
    func cancelPayment(with paymentID: String, completion: @escaping () -> Void) {
        APIManagerPaymentGateWay.shared.makeAPICall(endpoint: .cancelPayment(paymentID: paymentID)) { (result: Result<BCAResponse, Error>) in
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func deleteCheckout(with paymentId: String, completion: @escaping () -> Void) {
        APIManager.shared.makeAPICall(endpoint: .deleteCheckout(paymentId: paymentId)) { (result: Result<DeleteCheckOutResponse, Error>) in
            
            DispatchQueue.main.async {
                completion()
                
            }
        }
    }
    
    private func setupTableView() {
        paymentProcessTableVIew.delegate = self
        paymentProcessTableVIew.dataSource = self
        
        PaymentProcessSection.allCases.forEach { section in
            paymentProcessTableVIew.registerCellWithNib(section.cellType)
        }
    }
}

extension PaymentProcessViewController: UITableViewDelegate, UITableViewDataSource, CencelPaymentCellDelegate, AccoountVACellDelegate, EmptyCellDelegate{
    func btnAction(inCell cell: EmptyTableViewCell) {
        let vc = YourOrdersViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func copyVANumber(inCell cell: AccoountVATableViewCell) {
        if let vaNumber = cell.numberVALabel.text {
            UIPasteboard.general.string = vaNumber
            let customToast = CustomToast(message: "VA number copied to clipboard", backgroundColor: Constants.secondary!)
            customToast.showToast(duration: 0.5)
        }
    }
    
    
    func goToOrderDetails(inCell cell: AccoountVATableViewCell) {
        let vc = YourOrdersViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToHome(inCell cell: AccoountVATableViewCell) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func cencelPaymentBtn(inCell cell: CencelPaymentTableViewCell) {
        
        let actionYes: [String: () -> Void] = ["Yes": { [weak self] in
            let dispatchGroup = DispatchGroup()
            self?.popUpLoading.showInFull()
            dispatchGroup.enter()
            self?.cancelPayment(with: self!.paymentID) {
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            self?.deleteCheckout(with: self!.paymentID) {
                
                dispatchGroup.leave()
            }
            
            
            dispatchGroup.notify(queue: .main) {
                
                self?.popUpLoading.dismissImmediately()
                self?.navigationController?.popToRootViewController(animated: true)
                
            }
            
        }
        ]
        let actionNo: [String: () -> Void] = ["X": { }]
        
        let arrayActions = [actionYes, actionNo]
        
        showCustomAlertWith(
            title: "Cancel Payment",
            message: "are you sure you want to cancel it?",
            image: #imageLiteral(resourceName: "ic_error"),
            actions: arrayActions
        )
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PaymentProcessSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let paymentProcessSection = PaymentProcessSection(rawValue: section) else { return 0 }
        
        switch paymentProcessSection {
        case .expiredPayment, .accountVA, .cancelPayment:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let paymentProcessSection = PaymentProcessSection(rawValue: indexPath.section),
              let expiryTime = paymentBCA?.expiryTime,
              let createdOn = paymentBCA?.transactionTime,
              let totalPayment = paymentBCA?.grossAmount,
              let bankImageName = paymentBCA?.vaNumbers?.first?.bank ?? paymentBCA?.paymentType,
              let VA = paymentBCA?.vaNumbers?.first?.vaNumber ?? paymentBCA?.permataVaNumber
        else {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as EmptyTableViewCell
            cell.configure(withImageNamed: "ic_error", message: "Sorry Server Error", title: "Server Loss")
            cell.delegate = self
            cell.btnTextValue = "Check Your Status"
            tableView.isScrollEnabled = false
            tableView.frame.size.height = 729.0
            return cell
        }
        
        switch paymentProcessSection {
        case .expiredPayment:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ExpiredTimerPaymentTableViewCell
            cell.configureCell(transactionTime: createdOn, expiryTimeValue: expiryTime)
            return cell
            
        case .accountVA:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AccoountVATableViewCell
            cell.delegate = self
            cell.configure(totalPayment: "$\(totalPayment)", numberVA: VA, bankImageName: "ic_\(bankImageName)")
            return cell
            
        case .cancelPayment:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CencelPaymentTableViewCell
            cell.delegate = self
            tableView.contentInset.top = 100
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    
}

