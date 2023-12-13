import UIKit

protocol CustomTextFieldDelegate: AnyObject {
    func customTextFieldDidEndEditing(_ textField: CustomTextField)
}

class CustomTextField: UIView, UITextFieldDelegate {

    @IBOutlet weak var containerTextField: UIView!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var imageTextField: UIImageView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var passwordImageButton: UIImageView!

    weak var delegate: CustomTextFieldDelegate?
    var isPasswordField: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureGestures()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        configureGestures()
        containerTextField.layer.cornerRadius = 10.0
        inputTextField.delegate = self
    }

    // MARK: - Private Functions
    private func setupView() {
        let view = loadNib()
        view.frame = bounds
        addSubview(view)
    }

    private func configureGestures() {
        let inputTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        inputTextField.addGestureRecognizer(inputTextFieldTapGesture)

        let containerTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerTextField.addGestureRecognizer(containerTextFieldTapGesture)

        let passwordImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePasswordImageTap))
        passwordImageButton.addGestureRecognizer(passwordImageTapGesture)
    }

    @objc private func handleTap() {
        UIView.animate(withDuration: 0.2) {
            self.containerTextField.backgroundColor = UIColor(named: "Secondary")
            self.imageTextField.tintColor = UIColor(named: "BG2")
            self.inputTextField.becomeFirstResponder()
        }
    }

    @objc private func handlePasswordImageTap() {
        inputTextField.isSecureTextEntry.toggle()

        let imageName = inputTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        passwordImageButton.image = UIImage(systemName: imageName)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.containerTextField.backgroundColor = UIColor(named: "BG2")
            self.imageTextField.tintColor = UIColor(named: "secondary")
        }

        delegate?.customTextFieldDidEndEditing(self)
    }

    func configure(title: String, image: UIImage?, placeholder: String, errorText: String? = nil, isPasswordField: Bool = false) {
        titleTextField.text = title
        imageTextField.image = image
        inputTextField.placeholder = placeholder
        self.isPasswordField = isPasswordField

        if isPasswordField {
            passwordImageButton.isHidden = false
            passwordImageButton.isUserInteractionEnabled = true
            let imageName = inputTextField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
            passwordImageButton.image = UIImage(systemName: imageName)
        } else {
            passwordImageButton.isHidden = true
            passwordImageButton.isUserInteractionEnabled = false
        }
    }
}
