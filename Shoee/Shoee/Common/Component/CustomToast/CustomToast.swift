import UIKit

class CustomToast: UIView {
    static let topMargin: CGFloat = 70.0
    static let animationDuration: TimeInterval = 0.4
    static let toastHeight: CGFloat = 40.0
    static let fontName = "Poppins-SemiBold"

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: CustomToast.fontName, size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(message: String, backgroundColor: UIColor = .red) {
        super.init(frame: CGRect.zero)

        self.backgroundColor = backgroundColor
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        self.message = message
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var message: String = "" {
        didSet {
            label.text = message
        }
    }

    func showToast(duration: TimeInterval = 0.2) {
        guard let window = UIApplication.shared.keyWindow else { return }

        window.addSubview(self)

        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 30),
            self.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -30),
            self.heightAnchor.constraint(equalToConstant: CustomToast.toastHeight),
            self.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: -CustomToast.toastHeight)
        ])

        self.alpha = 0.0
        label.text = message
        window.layoutIfNeeded()

        UIView.animate(withDuration: CustomToast.animationDuration, animations: {
            self.alpha = 1.0
            self.frame.origin.y = CustomToast.topMargin
        }) { (completed) in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.hideToast()
            }
        }
    }

    func hideToast() {
        UIView.animate(withDuration: CustomToast.animationDuration, animations: {
            self.alpha = 0.0
            self.frame.origin.y = -CustomToast.toastHeight - CustomToast.topMargin
        }) { (completed) in
            self.resetToastProperties()
        }
    }

    private func resetToastProperties() {
        self.alpha = 0.0
        self.frame.origin.y = -CustomToast.toastHeight - CustomToast.topMargin
    }
}
