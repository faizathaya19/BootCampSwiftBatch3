import UIKit

// Define a delegate protocol for CustomTextField
protocol CustomTextFieldDelegate: AnyObject {
    func customTextFieldDidEndEditing(_ textField: CustomTextField)
}

class CustomTextField: UIView, UITextFieldDelegate {
    @IBOutlet weak var containerTextField: UIView!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var imageTextField: UIImageView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    // Delegate property
    weak var delegate: CustomTextFieldDelegate?

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGestures()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureGestures()
        containerTextField.layer.cornerRadius = 10.0
        inputTextField.delegate = self
    }

    // MARK: - Functions
    private func configureView() {
        let view = loadNib()
        view.frame = bounds
        addSubview(view)
    }

    private func configureGestures() {
        let imageTextFieldGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imageTextField.addGestureRecognizer(imageTextFieldGesture)

        let inputTextFieldGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        inputTextField.addGestureRecognizer(inputTextFieldGesture)

        let containerTextFieldGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerTextField.addGestureRecognizer(containerTextFieldGesture)
    }

    @objc private func handleTap() {
        UIView.animate(withDuration: 0.2) {
            self.containerTextField.backgroundColor = UIColor(named: "Secondary")
            self.imageTextField.tintColor = UIColor(named: "BG2")
            self.inputTextField.becomeFirstResponder()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.containerTextField.backgroundColor = UIColor(named: "BG2")
            self.imageTextField.tintColor = UIColor(named: "Secondary")
        }

        // Call delegate method if you have a delegate
        delegate?.customTextFieldDidEndEditing(self)
    }

    func configure(title: String, image: UIImage?, placeholder: String, errorText: String? = nil) {
        titleTextField.text = title
        imageTextField.image = image
        inputTextField.placeholder = placeholder
        errorLabel.text = errorText
        errorLabel.isHidden = errorText == nil
        errorLabel.textColor = UIColor(named: "Alert")
    }
}
