import UIKit

enum PINConstants {
    static let maxDigits = 4
    static let maxAttempts = 3
    static let lockoutTime: TimeInterval = 30
}

struct ContainerColors {
    static let defaultColor = UIColor.clear

    static func colorForDigit(_ digit: Int) -> UIColor {
        return UIColor(red: CGFloat(digit) / 10.0, green: 0.7, blue: 0.9, alpha: 1.0)
    }
}

class CustomPINViewController: UIViewController {

    @IBOutlet private var digitContainers: [UIView]!
    @IBOutlet private var numberButtons: [UIButton]!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var faceIDButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!

    private var enteredDigits: [Int] = [] {
        didSet {
            updateContainerColors()
            print(enteredDigits)
        }
    }

    private var attempts = 0
    private var isLockedOut = false
    private var countdownTimer: Timer?
    private var remainingLockoutTime: Int = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButtonActions()
        makeButtonsCircular()
        hideAlert()
    }

    private func updateContainerColors() {
        guard !isLockedOut else {
            showAlert(message: "Too many failed attempts. Please try again after \(Int(PINConstants.lockoutTime)) seconds.")
            return
        }

        for (index, container) in digitContainers.enumerated() {
            container.backgroundColor = enteredDigits.count > index ? ContainerColors.colorForDigit(enteredDigits[index]) : ContainerColors.defaultColor
        }

        deleteButton.isEnabled = !enteredDigits.isEmpty

        // Check if entered PIN is correct (you can replace this logic with your actual PIN validation logic)
        if enteredDigits.count == PINConstants.maxDigits {
            let enteredPIN = enteredDigits.map { String($0) }.joined()
            if enteredPIN == "2976" {
                // Correct PIN, navigate to HomeViewController
                navigateToHomeViewController()
            } else {
                // Incorrect PIN
                attempts += 1
                updateAlertLabel()
                if attempts >= PINConstants.maxAttempts {
                    // Lock out for 30 seconds
                    isLockedOut = true
                    startLockoutTimer()
                }
                showAlert(message: "Incorrect PIN. Please try again.")
                // Clear entered digits
                enteredDigits.removeAll()
                updateContainerColors()
            }
        }
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
        } else {
            updateAlertLabel()
        }
    }

    private func updateAlertLabel() {
        if isLockedOut {
            alertLabel.text = "Too many failed attempts. Locking out for \(remainingLockoutTime) seconds."
        } else {
            let remainingAttempts = PINConstants.maxAttempts - attempts
            if remainingAttempts > 0 {
                alertLabel.text = "Incorrect PIN. \(remainingAttempts) attempts remaining."
            } else {
                alertLabel.text = "Too many failed attempts. Locking out..."
            }
        }
    }

    private func showAlert(message: String) {
        alertLabel.text = message
        alertLabel.isHidden = false
    }

    private func hideAlert() {
        alertLabel.isHidden = true
    }

    private func navigateToHomeViewController() {
        // You can replace this with your actual navigation logic to the HomeViewController
        if let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            navigationController?.pushViewController(homeViewController, animated: true)
        }
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

    private func makeButtonsCircular() {
        let buttons: [UIButton] = [deleteButton, faceIDButton] + numberButtons

        for button in buttons {
            button.layer.cornerRadius = button.frame.size.width / 2.0
            button.clipsToBounds = true
        }

        deleteButton.isEnabled = !enteredDigits.isEmpty
    }
}
