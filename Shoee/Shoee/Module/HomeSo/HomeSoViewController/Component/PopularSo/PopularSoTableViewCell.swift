import UIKit
import SkeletonView

protocol ProductSelectionDelegate: AnyObject {
    func handleProductSelection(_ product: ProductModel)
}

class PopularSoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    weak var productSelectionDelegate: ProductSelectionDelegate?
    
    var popularData: [ProductModel] = [] {
        didSet {
            popularCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.registerCellWithNib(PopularSoCollectionViewCell.self)
    }
}

extension PopularSoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PopularSoCollectionViewCell
        
        let popularItem = popularData[indexPath.item]
        configureCell(cell, with: popularItem)
        
        return cell
    }
    
    private func configureCell(_ cell: PopularSoCollectionViewCell, with popularItem: ProductModel) {
        let thirdGallery = popularItem.galleries?.dropFirst(3).first?.url ?? Constants.defaultImageURL
        
        cell.configure(name: popularItem.name,
                       price: "$\(popularItem.price)",
                       imageURL: thirdGallery,
                       category: popularItem.category?.name)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < popularData.count else {
            return
        }
        let selectedProduct = popularData[indexPath.item]
        productSelectionDelegate?.handleProductSelection(selectedProduct)
    }
}

extension PopularSoTableViewCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "PopularSoCollectionViewCell"
    }
    
}
