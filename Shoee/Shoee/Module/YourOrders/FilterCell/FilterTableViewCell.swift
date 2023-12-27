import UIKit

struct FilterOption {
    let action: String
    let name: String
}

class FilterTableViewCell: BaseTableCell, UICollectionViewDelegate, UICollectionViewDataSource, FillterCollectionViewCellDelegate {
    
    @IBOutlet weak var fillterCollectionView: UICollectionView!
  
    let filterOptions = [
        FilterOption(action: "settlement", name: "Success"),
        FilterOption(action: "pending", name: "Pending"),
        FilterOption(action: "expire", name: "Expired")
    ]

    weak var delegate: FillterCollectionViewCellDelegate?
    var selectedFilter: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fillterCollectionView.delegate = self
        fillterCollectionView.dataSource = self
        fillterCollectionView.registerCellWithNib(FillterCollectionViewCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOptions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FillterCollectionViewCell

        let filterOption = filterOptions[indexPath.item]
        let isFilterOn = filterOption.action == selectedFilter
        cell.configure(with: filterOption, isFilterOn: isFilterOn, delegate: self)
        return cell
    }

    func didSelectFilterOption(_ option: String, isFilterOn: Bool) {
        if isFilterOn {
            selectedFilter = option
        } else {
            selectedFilter = nil
        }
        
        fillterCollectionView.reloadData()
        
        delegate?.didSelectFilterOption(option, isFilterOn: isFilterOn)
    }
}
