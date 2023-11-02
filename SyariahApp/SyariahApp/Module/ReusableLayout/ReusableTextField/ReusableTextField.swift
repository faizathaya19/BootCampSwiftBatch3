import UIKit

class ReusableTextField: UIView {
    
    @IBOutlet private weak var titleTextField: UILabel!
    
    @IBOutlet weak var formTextfield: UITextField!
    
    private let nibName = "ReusableTextField"
    
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
    
    func setup(title: String) {
        titleTextField.text = title
    }
}
