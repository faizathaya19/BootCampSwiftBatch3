import UIKit

protocol FillterCollectionViewCellDelegate: AnyObject {
    func didSelectFilterOption(_ option: String, isFilterOn: Bool)
}

class FillterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameContainer: UIView!
    @IBOutlet weak var nameFillter: UILabel!
    private var isFilterOn: Bool = false
    weak var delegate: FillterCollectionViewCellDelegate?
    private var filterOption: FilterOption?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        addGestureRecognizer(tapGesture)
        nameContainer.makeCornerRadius(15)
    }

    func configure(with filterOption: FilterOption, isFilterOn: Bool, delegate: FillterCollectionViewCellDelegate?) {
        self.filterOption = filterOption
        self.isFilterOn = isFilterOn
        self.delegate = delegate
        nameFillter.text = filterOption.name
        updateUI()
    }
    
    @objc private func didTapCell() {
        isFilterOn = !isFilterOn
        updateUI()
        guard let filterOption = filterOption else { return }
        delegate?.didSelectFilterOption(filterOption.action, isFilterOn: isFilterOn)
    }

    private func updateUI() {
        nameContainer.backgroundColor = isFilterOn ? Constants.secondary : Constants.bG4
        nameFillter.textColor = isFilterOn ? Constants.bG4 : UIColor.black
    }
}
