import UIKit
import SkeletonView

protocol CategorySoDelegate: AnyObject {
    func categorySelected(withId categoryId: Int)
}

class CategorySoTableViewCell: BaseTableCell {
    
    @IBOutlet private weak var categorySoCollectionView: UICollectionView!
    weak var delegate: CategorySoDelegate?
    
    var skeletonVieww: Bool = true
    
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
        categorySoCollectionView.registerCellWithNib(CategorySoCollectionViewCell.self)
    }
    
    func configure(skeletonView: Bool){
        isSkeletonable = skeletonView
        skeletonVieww = skeletonView
    }
}

extension CategorySoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategorySoCollectionViewCell
        
        let category = CategoryData[indexPath.item]
        
        cell.categoryTitle.text = category.name
        cell.configureAppearance(selected: category.id == selectedCategoryId, skeletonView: skeletonVieww)
        
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
        return "CategorySoCollectionViewCell"
    }    
}
