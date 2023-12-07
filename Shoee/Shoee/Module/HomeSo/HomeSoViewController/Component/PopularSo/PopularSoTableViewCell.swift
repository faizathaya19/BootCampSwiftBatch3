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
        popularCollectionView.register(UINib(nibName: "PopularSoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "popularSoCollectionViewCell")
    }
}

extension PopularSoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularSoCollectionViewCell", for: indexPath) as? PopularSoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let popularItem = popularData[indexPath.item]
        configureCell(cell, with: popularItem)
        
        return cell
    }
    
    private func configureCell(_ cell: PopularSoCollectionViewCell, with popularItem: ProductModel) {
        if let thirdGallery = popularItem.galleries?.dropFirst(3).first {
            let thirdGalleryURL = thirdGallery.url
            cell.configure(name: popularItem.name,
                           price: "$\(popularItem.price)",
                           imageURL: thirdGalleryURL,
                           category: popularItem.category.name)
        } else {
            cell.configure(name: popularItem.name,
                           price: "$\(popularItem.price)",
                           imageURL: "https://example.com/default-image.jpg",
                           category: popularItem.category.name)
        }
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
        return "popularSoCollectionViewCell"
    }
    
    
}
