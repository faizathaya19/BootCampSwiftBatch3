import UIKit
import RxCocoa
import RxSwift

class ReusableTextField: UIView {

    @IBOutlet private weak var titleTextField: UILabel!
    @IBOutlet weak var formTextfield: UITextField!
    @IBOutlet weak var labelMessage: UILabel!

    private let nibName = "ReusableTextField"

    var textObservable: Observable<String> {
        return formTextfield.rx.text.orEmpty.asObservable()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
    }

    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    func setup(title: String, label: String? = nil) {
        titleTextField.text = title
        formTextfield.accessibilityLabel = title
        labelMessage.text = label
        labelMessage.isHidden = label == nil // Initially, hide the labelMessage if label is nil
    }

}
