// RegisterViewController.swift
import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: UIViewController {

    @IBAction func privacyPolicyButton(_ sender: Any) {
        let vc = PrivacyPolicyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func signIn(_ sender: Any) {
        _ = LoginViewController()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signUp(_ sender: Any) {
        validateAndSignUp()
        
    }

    @IBOutlet weak var firstNameField: ReusableTextField!
    @IBOutlet weak var lastNameField: ReusableTextField!
    @IBOutlet weak var emailField: ReusableTextField!
    @IBOutlet weak var passwordField: ReusableTextField!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        hideAllErrorMessages()
    }

    private func setupTextFields() {
        firstNameField.setup(title: "First Name", label: "Required")
        lastNameField.setup(title: "Last Name", label: "Required")
        emailField.setup(title: "Email", label: "Enter a valid email")
        passwordField.setup(title: "Password", label: "Password must be at least 8 characters")

        bindTextFields()
    }

    private func bindTextFields() {
        firstNameField.textObservable
            .subscribe(onNext: { text in
                self.handleTextFieldChange(text: text, textField: self.firstNameField)
            })
            .disposed(by: disposeBag)

        lastNameField.textObservable
            .subscribe(onNext: { text in
                self.handleTextFieldChange(text: text, textField: self.lastNameField)
            })
            .disposed(by: disposeBag)

        emailField.textObservable
            .subscribe(onNext: { text in
                self.handleTextFieldChange(text: text, textField: self.emailField)
            })
            .disposed(by: disposeBag)

        passwordField.textObservable
            .subscribe(onNext: { text in
                self.handleTextFieldChange(text: text, textField: self.passwordField)
            })
            .disposed(by: disposeBag)
    }

    private func handleTextFieldChange(text: String, textField: ReusableTextField) {
        textField.labelMessage.isHidden = true // Hide the labelMessage by default

        if text.isEmpty {
            // Set the text field color to red
            textField.formTextfield.layer.borderColor = UIColor.red.cgColor
            textField.labelMessage.isHidden = false // Show the labelMessage for empty field
        } else {
            // Set the text field color to its default color
            textField.formTextfield.layer.borderColor = UIColor.systemGray.cgColor

            // Additional validation for specific fields
            if textField == emailField {
                if !isValidEmail(email: text) {
                    // Set the text field color to red for invalid email format
                    textField.formTextfield.layer.borderColor = UIColor.red.cgColor
                    textField.labelMessage.isHidden = false // Show the labelMessage for invalid email
                }
            } else if textField == passwordField {
                if text.count < 8 {
                    // Set the text field color to red for passwords less than 8 characters
                    textField.formTextfield.layer.borderColor = UIColor.red.cgColor
                    textField.labelMessage.isHidden = false // Show the labelMessage for short password
                }
            }
        }
    }

    private func validateAndSignUp() {
        hideAllErrorMessages()

        var isSignUpValid = true

        // Validate first name
        if !isFieldValid(text: firstNameField.formTextfield.text) {
            isSignUpValid = false
            showErrorMessage(for: firstNameField, message: "First name is required")
        }

        // Validate last name
        if !isFieldValid(text: lastNameField.formTextfield.text) {
            isSignUpValid = false
            showErrorMessage(for: lastNameField, message: "Last name is required")
        }

        // Validate email
        if !isFieldValid(text: emailField.formTextfield.text) || !isValidEmail(email: emailField.formTextfield.text!) {
            isSignUpValid = false
            showErrorMessage(for: emailField, message: "Enter a valid email")
        }

        // Validate password
        if !isFieldValid(text: passwordField.formTextfield.text) || passwordField.formTextfield.text!.count < 8 {
            isSignUpValid = false
            showErrorMessage(for: passwordField, message: "Password must be at least 8 characters")
        }

        if isSignUpValid {
            // Perform sign-up logic
            navigateToLogin()
        }
    }

    private func isFieldValid(text: String?) -> Bool {
        return !(text?.isEmpty ?? true)
    }

    private func showErrorMessage(for textField: ReusableTextField, message: String) {
        textField.labelMessage.text = message
        textField.labelMessage.isHidden = false
        textField.formTextfield.layer.borderColor = UIColor.red.cgColor
    }

    private func hideAllErrorMessages() {
        firstNameField.labelMessage.isHidden = true
        lastNameField.labelMessage.isHidden = true
        emailField.labelMessage.isHidden = true
        passwordField.labelMessage.isHidden = true
    }

    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func navigateToLogin() {
        let loginController = LoginViewController()
        navigationController?.pushViewController(loginController, animated: true)

    }

}
