import UIKit

public struct DialogData {
    public var title: String?
    public var message: String?
}

class ReusableDialogShowViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var theContentView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var textMessage: UILabel!
    @IBOutlet weak var titleMessage: UILabel!

    // MARK: - Actions
    @IBAction func actionButton(_ sender: Any) {
        hide()
    }

    // MARK: - Initialization
    init() {
        super.init(nibName: "ReusableDialogShowViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - Configuration
    func configureView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.theContentView.layer.cornerRadius = 20
    }

    // MARK: - Presentation
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }

    private func show() {
        UIView.animate(withDuration: Constants.animationDuration, delay: 0) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    // MARK: - Dismissal
    func hide() {
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }

    // MARK: - Error Message
    func showError(dialogData: DialogData) {
        // Check if labels are not nil before setting text
        self.textMessage?.text = dialogData.message
        self.titleMessage?.text = dialogData.title
    }
}

// Constants
private extension ReusableDialogShowViewController {
    enum Constants {
        static let animationDuration: TimeInterval = 0.5
    }
}
