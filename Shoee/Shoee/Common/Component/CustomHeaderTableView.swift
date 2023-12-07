import UIKit

class CustomTableHeaderView: UIView {

    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 16)
        label.textColor = UIColor(named: "Secondary") // Assuming "SecondaryColor" is defined in your assets
        return label
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    // MARK: - Public Method
    func configure(withTitle title: String) {
        titleLabel.text = title
    }

    // MARK: - Private Method
    private func setupSubviews() {
        backgroundColor = UIColor.clear

        titleLabel.frame = CGRect(x: 15, y: 5, width: bounds.width - 30, height: 30)
        addSubview(titleLabel)
    }
}
