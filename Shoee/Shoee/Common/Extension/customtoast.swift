import UIKit

class CustomToast: UIView {

    private let toastLabel = UILabel()

    init(frame: CGRect, message: String) {
        super.init(frame: frame)

        // Customize the toast appearance
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.layer.cornerRadius = 10

        // Configure the label
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0
        toastLabel.text = message
        self.addSubview(toastLabel)

        // Adjust label constraints
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            toastLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            toastLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            toastLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showInView(view: UIView, duration: TimeInterval = 2.0) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        // Center the toast horizontally
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Set initial position above the view
        let topConstraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: -self.frame.size.height)
        topConstraint.isActive = true

        UIView.animate(withDuration: 0.5, animations: {
            topConstraint.constant = view.bounds.height / 2 - self.frame.size.height / 2
            self.superview?.layoutIfNeeded()
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                UIView.animate(withDuration: 0.2, animations: {
                    topConstraint.constant = -self.frame.size.height
                    self.superview?.layoutIfNeeded()
                }) { _ in
                    self.removeFromSuperview()
                }
            }
        }
    }
}
