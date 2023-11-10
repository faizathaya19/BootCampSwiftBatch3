import UIKit

class BaseTableCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

class SetupHomeTableViewCell: BaseTableCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    
    var homeSetupTable: HomeSetupTable = .header {
        didSet {
            homeCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        homeCollectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "headerCell")
        homeCollectionView.register(UINib(nibName: "CategoryListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryListCell")

    }
    
    private func configureCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        switch homeSetupTable {
        case .header:
            guard let headerCell = cell as? HeaderCollectionViewCell else { return }
            // Configure headerCell
        case .categoryList:
            guard let categoryListCell = cell as? CategoryListCollectionViewCell else { return }
        case .popularProd:
            guard let popularProdCell = cell as? CategoryListCollectionViewCell else { return }
            // Configure popularProdCell
        case .newArrival:
            guard let newArrivalCell = cell as? CategoryListCollectionViewCell else { return }
            // Configure newArrivalCell
        }
    }
    
    private func configureCategoryListCell(_ cell: CategoryListCollectionViewCell, at indexPath: IndexPath) {
        // Configure categoryListCell
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        switch homeSetupTable {
        case .header:
            cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath)
        case .categoryList:
            cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryListCell", for: indexPath)
        case .popularProd:
            cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryListCell", for: indexPath)
        case .newArrival:
            cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryListCell", for: indexPath)
        }
        
        configureCell(cell, at: indexPath)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch homeSetupTable {
        case .header:
            return CGSize(width: 393, height: 92)
        case .categoryList:
            return CGSize(width: 100, height: 100)
        case .popularProd, .newArrival:
            return CGSize(width: 300, height: 170)
        }
    }
}
