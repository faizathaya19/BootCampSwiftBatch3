import UIKit
import Kingfisher
import SkeletonView

class PopularProductTableViewCell: BaseTableCell {

    @IBOutlet weak var popularProductCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    
    var navigationController: UINavigationController?
    var popularProducts: [ProductModel] = [] {
        didSet {
            popularProductCollectionView.reloadData()
            popularProductCollectionView.hideSkeleton()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }

    func configure(withTitle title: String?, title2: String) {
        titleLabel.text = title
        titleLabel2.text = title2
        fetchPopularProducts()
    }

    private func configureCollectionView() {
        popularProductCollectionView.delegate = self
        popularProductCollectionView.dataSource = self
        popularProductCollectionView.register(UINib(nibName: "PopularProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "popularProductCollectionViewCell")
    }

    private func fetchPopularProducts() {
        popularProductCollectionView.showAnimatedGradientSkeleton()
        ProductsService.shared.getProducts(tags: "popular") { [weak self] result in
            switch result {
            case .success(let products):
                self?.popularProducts = products
                self?.popularProductCollectionView.hideSkeleton()
            case .failure(let error):
                print("Failed to fetch popular products: \(error.localizedDescription)")
                self?.popularProductCollectionView.hideSkeleton()
            }
        }
    }
}

extension PopularProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularProductCollectionViewCell", for: indexPath) as! PopularProductCollectionViewCell

        let product = popularProducts[indexPath.item]
        if let thirdGallery = product.galleries?.dropFirst(3).first {
            let thirdGalleryURL = thirdGallery.url
            // Use the third gallery URL
            cell.configure(name: product.name,
                           price: "$\(product.price)",
                           imageURL: thirdGalleryURL,
                           category: product.category.name)
        } else {
            // Use a default image URL or handle the case where the third gallery is not available
            cell.configure(name: product.name,
                           price: "$\(product.price)",
                           imageURL: "https://example.com/default-image.jpg",
                           category: product.category.name)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = popularProducts[indexPath.item]
        let detailViewController = DetailProductViewController(productID: selectedProduct.id)
        detailViewController.product = selectedProduct
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: false)
    }
}
