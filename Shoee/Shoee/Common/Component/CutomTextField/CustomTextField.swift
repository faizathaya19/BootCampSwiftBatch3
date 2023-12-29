import UIKit

enum ValidationType {
    case none
    case phoneNumber
}

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
    var validationType: ValidationType = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        configureGestures()
        containerTextField.makeCornerRadius(10)
        inputTextField.delegate = self
    }
    
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
            self.containerTextField.backgroundColor = Constants.secondary
            self.imageTextField.tintColor = Constants.bG2
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
            self.containerTextField.backgroundColor = Constants.bG2
            self.imageTextField.tintColor = Constants.secondary
        }
        
        delegate?.customTextFieldDidEndEditing(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch validationType {
        case .phoneNumber:
            return inputTextField.validatePhoneNumberInput(in: range, replacementString: string, maxLength: 14)
        case .none:
            return true
        }
    }
    
    
    func configure(title: String, image: UIImage?, placeholder: String, errorText: String? = nil, isPasswordField: Bool = false, validationType: ValidationType = .none) {
        titleTextField.text = title
        imageTextField.image = image
        inputTextField.placeholder = placeholder
        self.isPasswordField = isPasswordField
        self.validationType = validationType
        
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
