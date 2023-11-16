import UIKit

protocol SetupHomeCellDelegate: AnyObject {
    func didSelectCategory(_ category: Category)
}

struct Category {
    let id: Int
    let name: String
}

class BaseTableCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

class SetupHomeTableViewCell: BaseTableCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var homeCollectionView: UICollectionView!

    var categoryList: [Category] = []

    var selectedCategoryIndex: Int? = nil

    var homeSetupTable: HomeSetupTable = .header {
        didSet {
            switch homeSetupTable {
            case .categoryList:
                categoryList = [
                    Category(id: 6, name: "All Shoes"),
                    Category(id: 5, name: "Running"),
                    Category(id: 4, name: "Training"),
                    Category(id: 3, name: "Basketball"),
                    Category(id: 2, name: "Hiking"),
                    Category(id: 1, name: "Sport")
                ]
                if let index = categoryList.firstIndex(where: { $0.id == 6 }) {
                    selectedCategoryIndex = categoryList[index].id
                }
            default:
                break
            }
            homeCollectionView.reloadData()
        }
    }

    weak var delegate: SetupHomeCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self

        homeCollectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "headerCell")
        homeCollectionView.register(UINib(nibName: "CategoryListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryListCell")

        if let flowLayout = homeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = (homeSetupTable == .categoryList) ? .vertical : .horizontal
        }

        homeCollectionView.reloadData()
    }

    private func configureCategoryListCell(_ cell: CategoryListCollectionViewCell, at indexPath: IndexPath) {
        let category = categoryList[indexPath.item]
        cell.categoryTitle.text = category.name

        if selectedCategoryIndex == category.id {
            cell.viewContainer.backgroundColor = UIColor(named: "Primary")
            cell.viewContainer.layer.borderWidth = 0
            cell.viewContainer.layer.borderColor = UIColor.clear.cgColor
            cell.categoryTitle.textColor = UIColor(named: "PrimaryText")
            cell.categoryTitle.font = UIFont.boldSystemFont(ofSize: cell.categoryTitle.font.pointSize)
        } else {
            cell.viewContainer.backgroundColor = UIColor.clear
            cell.viewContainer.layer.borderWidth = 1.0
            cell.viewContainer.layer.borderColor = UIColor.gray.cgColor
            cell.categoryTitle.textColor = UIColor(named: "SecondaryText")
            cell.categoryTitle.font = UIFont.systemFont(ofSize: cell.categoryTitle.font.pointSize, weight: .regular)
        }
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch homeSetupTable {
        case .categoryList:
            return categoryList.count
        default:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell

        switch homeSetupTable {
        case .header:
            cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath)
        case .categoryList:
            cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryListCell", for: indexPath)
            if let categoryCell = cell as? CategoryListCollectionViewCell {
                configureCategoryListCell(categoryCell, at: indexPath)
            }
        default:
            // Handle other cases if needed
            cell = UICollectionViewCell()
        }

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch homeSetupTable {
        case .header:
            return CGSize(width: 393, height: 92)
        case .categoryList:
            return CGSize(width: 91, height: 41)
        default:
            // Adjust size for other cases if needed
            return CGSize(width: 100, height: 100)
        }
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < categoryList.count {
            selectedCategoryIndex = categoryList[indexPath.item].id
            print("Selected category index: \(selectedCategoryIndex ?? -1)")
            collectionView.reloadData()

            // Notify the delegate (HomeViewController) about the selected category
            delegate?.didSelectCategory(categoryList[indexPath.item])
        } else {
            print("Invalid index selected")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch homeSetupTable {
        case .categoryList:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        default:
            return UIEdgeInsets.zero
        }
    }
}
