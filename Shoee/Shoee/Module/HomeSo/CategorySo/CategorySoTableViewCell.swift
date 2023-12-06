import UIKit

protocol CategorySoDelegate: AnyObject {
    func didSelectCategory(withId categoryId: Int)
}

class CategorySoTableViewCell: BaseTableCell {
    
    @IBOutlet private weak var categorySoCollectionView: UICollectionView!
    weak var delegate: CategorySoDelegate?
    
    var CategoryData: [CategoryModel] = []
    
    var selectedCategoryId: Int? {
        didSet {
            DispatchQueue.main.async {
                self.categorySoCollectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        categorySoCollectionView.reloadData() // Reload data after setting up the collection view
    }
    
    private func setupCollectionView() {
        categorySoCollectionView.delegate = self
        categorySoCollectionView.dataSource = self
        categorySoCollectionView.register(UINib(nibName: "CategorySoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categorySoCollectionViewCell")
    }
    
    @objc func didSelectCategory(withId categoryId: Int) {
        selectedCategoryId = categoryId
        delegate?.didSelectCategory(withId: categoryId)
    }
}

extension CategorySoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorySoCollectionViewCell", for: indexPath) as? CategorySoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let categoryItem = CategoryData[indexPath.item]
        
        cell.categoryTitle.text = categoryItem.name
        if let selectedCategoryId = selectedCategoryId, categoryItem.id == selectedCategoryId {
            configureSelectedCategoryCell(cell)
        } else {
            configureUnselectedCategoryCell(cell)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = CategoryData[indexPath.item]
        didSelectCategory(withId: selectedCategory.id)
    }
    
    private func configureSelectedCategoryCell(_ cell: CategorySoCollectionViewCell) {
        cell.viewContainer.backgroundColor = UIColor(named: "Primary")
        cell.viewContainer.layer.borderWidth = 0
        cell.viewContainer.layer.borderColor = UIColor.clear.cgColor
        cell.categoryTitle.textColor = UIColor(named: "PrimaryText")
        cell.categoryTitle.font = UIFont.boldSystemFont(ofSize: cell.categoryTitle.font.pointSize)
    }
    
    private func configureUnselectedCategoryCell(_ cell: CategorySoCollectionViewCell) {
        cell.viewContainer.backgroundColor = UIColor.clear
        cell.viewContainer.layer.borderWidth = 1.0
        cell.viewContainer.layer.borderColor = UIColor.gray.cgColor
        cell.categoryTitle.textColor = UIColor(named: "SecondaryText")
        cell.categoryTitle.font = UIFont.systemFont(ofSize: cell.categoryTitle.font.pointSize, weight: .regular)
    }
}
