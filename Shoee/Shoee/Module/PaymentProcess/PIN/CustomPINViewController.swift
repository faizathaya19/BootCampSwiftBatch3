import UIKit
import Lottie

struct PINConstants {
    static let maxDigits = 4
    static let maxAttempts = 3
    static let lockoutTime: TimeInterval = 30
    static let correctPIN = "2976"
}

enum ContainerColors {
    static let defaultColor = UIColor.clear
    
    static func color(forDigit digit: Int) -> UIColor {
        return UIColor(red: CGFloat(digit) / 10.0, green: 0.7, blue: 0.9, alpha: 1.0)
    }
}

class CustomPINViewController: UIViewController {
    
    @IBOutlet private weak var forAnimationSuccess: UIView!
    @IBOutlet private var digitContainers: [UIView]!
    @IBOutlet private var numberButtons: [UIButton]!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var faceIDButton: UIButton!
    @IBOutlet private weak var alertLabel: UILabel!
    
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "success_pin_lottie")
        view.loopMode = .playOnce
        view.animationSpeed = 1.0
        view.isHidden = true
        return view
    }()

    private var enteredDigits: [Int] = [] {
        didSet {
            updateContainerColors()
        }
    }
    
    var itemList: [Items] = []
    var paymentBCA: BCAResponse?
    var dataOther: CheckOut?
    var paymentSelectionData: PaymentSelectModel?
    var totalPrice: Int16 = 0
    var totalQuantity: Int16 = 0
    
    var orderId: String?
    
    private var attempts = 0
    private var isLockedOut = false
    private var countdownTimer: Timer?
    private var remainingLockoutTime = 0
    private var areButtonsEnabled = true
    
    var onCorrectPINEntered: (() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButtonActions()
        makeButtonsCircular()
        makeContainersCircular()
        hideAlert()
        enableDisableButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forAnimationSuccess.isHidden = true
        setupAnimationView()
    }

    private func setupAnimationView() {
        forAnimationSuccess.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: forAnimationSuccess.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: forAnimationSuccess.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: forAnimationSuccess.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: forAnimationSuccess.heightAnchor)
        ])
    }
    
    private func updateContainerColors() {
        guard !isLockedOut else {
            showAlert(message: "Too many failed attempts. Please try again after \(remainingLockoutTime) seconds.")
            digitContainers.forEach { $0.backgroundColor = UIColor.red }
            return
        }
        
        for (index, container) in digitContainers.enumerated() {
            container.backgroundColor = enteredDigits.count > index ? ContainerColors.color(forDigit: enteredDigits[index]) : ContainerColors.defaultColor
        }
        
        deleteButton.isEnabled = !enteredDigits.isEmpty
        
        if enteredDigits.count == PINConstants.maxDigits {
            let enteredPIN = enteredDigits.map { String($0) }.joined()
            if enteredPIN == PINConstants.correctPIN {
                showSuccessAnimation()
            } else {
                handleIncorrectPIN()
            }
        }
    }
    
    private func showSuccessAnimation() {
        animationView.isHidden = false
        digitContainers.forEach { $0.isHidden = true }
        alertLabel.isHidden = true
        animationView.play()
        self.forAnimationSuccess.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            var co: CheckOutViewModel!
            co = CheckOutViewModel()
            co.itemList = self?.itemList ?? []
            co.dataOther = self?.dataOther
            co.paymentSelectionData = self?.paymentSelectionData
            self?.bcaCheckout()
            self?.checkOutData()
  
            self?.forAnimationSuccess.isHidden = true
       
        }
    }
    
    private func handleIncorrectPIN() {
        attempts += 1
        if attempts >= PINConstants.maxAttempts {
            isLockedOut = true
            startLockoutTimer()
        }
        let remainingAttempts = PINConstants.maxAttempts - attempts
        showAlert(message: "Incorrect PIN. \(remainingAttempts) attempts remaining.")
        enteredDigits.removeAll()
        updateContainerColors()
        digitContainers.forEach { $0.backgroundColor = UIColor.red }
    }

    private func startLockoutTimer() {
        remainingLockoutTime = Int(PINConstants.lockoutTime)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLockoutTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateLockoutTimer() {
        remainingLockoutTime -= 1
        if remainingLockoutTime <= 0 {
            countdownTimer?.invalidate()
            countdownTimer = nil
            attempts = 0
            isLockedOut = false
            hideAlert()
            areButtonsEnabled = true
            enableDisableButtons()
        } else {
            areButtonsEnabled = false
            enableDisableButtons()
            showAlert(message: "Too many failed attempts. Please try again after \(remainingLockoutTime) seconds.")
        }
    }
    
    private func showAlert(message: String) {
        alertLabel.text = message
        alertLabel.isHidden = false
    }
    
    private func hideAlert() {
        alertLabel.isHidden = true
    }
    
    private func setupButtonActions() {
        for button in numberButtons {
            button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor(named: "secondary")
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        sender.backgroundColor = UIColor(named: "BG2")
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let digit = Int(sender.titleLabel?.text ?? "") else { return }
        
        if enteredDigits.count < PINConstants.maxDigits {
            enteredDigits.append(digit)
        }
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        if !enteredDigits.isEmpty {
            enteredDigits.removeLast()
            updateContainerColors()
        }
    }
    
    private func makeContainersCircular() {
        let views: [UIView] = digitContainers
        
        for view in views {
            view.layer.cornerRadius = view.frame.size.width / 2.0
            view.clipsToBounds = true
        }
    }
    
    private func makeButtonsCircular() {
        let buttons: [UIButton] = [deleteButton, faceIDButton] + numberButtons
        
        for button in buttons {
            button.layer.cornerRadius = button.frame.size.width / 2.0
            button.clipsToBounds = true
        }
        
        deleteButton.isEnabled = !enteredDigits.isEmpty
    }
    
    private func enableDisableButtons() {
        for button in numberButtons {
            button.isEnabled = areButtonsEnabled
        }
        deleteButton.isEnabled = areButtonsEnabled && !enteredDigits.isEmpty
    }
    
    func performBCACheckout(with bcaParam: BCAParam, completion: @escaping (Result<BCAResponse, Error>) -> Void) {
            APIManagerPaymentGateWay.shared.makeAPICall(endpoint: .vaBCA(bcaParam)) { (result: Result<BCAResponse, Error>) in
                switch result {
                case .success(let response):
                    self.paymentBCA = response
                
                case .failure(let error):
                    print(error)
                }
            }
        }


    func performCheckOut(with checkOut: CheckOutParam, completion: @escaping (Result<ResponseCheckOut, Error>) -> Void) {
        APIManager.shared.makeAPICall(endpoint: .checkout(checkOut), completion: completion)
    }
    
    func generateOrderID() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let currentDateTime = Date()
        orderId = "order-\(dateFormatter.string(from: currentDateTime))"
    }

    
    func checkOutData() {
        guard let address = dataOther?.address else {
            return
        }
        
        totalPrice = Int16(itemList.reduce(0) { $0 + Double($1.price) * Double($1.quantity) })
        
        let item = itemList.map { item in
            return itemParam(id: "\(item.productID)", quantity: Int(item.quantity))
        }
                
        performCheckOut(
            with: CheckOutParam(
                address: address,
                items: item,
                status: "PENDING",
                totalPrice: Int(totalPrice),
                shippingPrice: 13000,
                payment: paymentSelectionData?.name ?? "",
                paymentId: orderId!
            )
        ) { result in
            self.dismiss(animated: true, completion: nil)
            self.onCorrectPINEntered?()
        }
    }
    
    func bcaCheckout() {
        totalPrice = Int16(itemList.reduce(0) { $0 + Double($1.price) * Double($1.quantity) })

        let transaction = transactionDetails(orderId: orderId!, grossAmount: Int(totalPrice))
        let bank = bankTransfer(bank: paymentSelectionData?.title ?? "")
        let itemDetailsArray = itemList.map { item in
            return itemDetails(id: "\(item.productID)", price: Int(item.price), quantity: Int(item.quantity), name: item.name ?? "")
        }

        let customer = customerDetails(email: "test", firstName: "faiz", lastName: "ramadhan", phone: "0822")

        performBCACheckout(
            with: BCAParam(
                transactionDetails: transaction,
                bankTransfer: bank,
                customerDetails: customer,
                itemDetails: itemDetailsArray
            )
        ){ result in
           
        }
    }

}

