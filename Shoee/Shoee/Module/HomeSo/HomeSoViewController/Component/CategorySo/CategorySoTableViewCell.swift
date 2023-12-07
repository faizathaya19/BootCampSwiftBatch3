import UIKit
import SkeletonView

protocol CategorySoDelegate: AnyObject {
    func categorySelected(withId categoryId: Int)
}

class CategorySoTableViewCell: BaseTableCell {
    
    @IBOutlet private weak var categorySoCollectionView: UICollectionView!
    weak var delegate: CategorySoDelegate?
    
    var CategoryData: [CategoryModel] = [] {
        didSet {
            categorySoCollectionView.reloadData()
        }
    }
    
    var selectedCategoryId: Int? {
        didSet {
            categorySoCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        categorySoCollectionView.delegate = self
        categorySoCollectionView.dataSource = self
        categorySoCollectionView.register(UINib(nibName: "CategorySoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categorySoCollectionViewCell")
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension CategorySoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorySoCollectionViewCell", for: indexPath) as? CategorySoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = CategoryData[indexPath.item]
        
        cell.categoryTitle.text = category.name
        cell.configureAppearance(selected: category.id == selectedCategoryId)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = CategoryData[indexPath.item]
        delegate?.categorySelected(withId: selectedCategory.id)
    }
}


extension CategorySoTableViewCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "categorySoCollectionViewCell"
    }
    
    
}
