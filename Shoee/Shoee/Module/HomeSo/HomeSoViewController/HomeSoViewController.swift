import UIKit
import SkeletonView

class HomeSoViewController: UIViewController {
    @IBOutlet private weak var homeSoTableView: UITableView!
    
    private var viewModel = HomeSoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        homeSoTableView.showAnimatedGradientSkeleton()
        viewModel.setNavigationController(self.navigationController)
        viewModel.updateHandler = { [weak self] in
            self?.reloadData()
        }
        viewModel.fetchData()
    }
    
    private func setupTableView() {
        homeSoTableView.delegate = self
        homeSoTableView.dataSource = self
        registerCells()
        homeSoTableView.rowHeight = UITableView.automaticDimension
        homeSoTableView.contentInset.bottom = 130
    }
    
    private func registerCells() {
        HomeSo.allCases.forEach { cell in
            homeSoTableView.registerCellWithNib(cell.cellTypes)
        }
    }
    
    private func reloadData() {
        homeSoTableView.reloadData()
        homeSoTableView.hideSkeleton()
    }
}

extension HomeSoViewController: UITableViewDelegate, UITableViewDataSource, CategorySoDelegate, ProductSelectionDelegate {
    
    func handleProductSelection(_ product: ProductModel) {
        viewModel.handleProductSelection(product)
    }
    
    func categorySelected(withId categoryId: Int) {
        viewModel.selectedCategoryId = categoryId
        viewModel.fetchData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY >= contentHeight - screenHeight, !viewModel.isLoading {
            
            let activityIndicatorView = UIActivityIndicatorView(style: .medium)
            
              activityIndicatorView.startAnimating()
              homeSoTableView.tableFooterView = activityIndicatorView
            
            viewModel.loadMoreData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSo.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let homeSoSection = HomeSo(rawValue: section) else {
            return 0
        }
        
        switch homeSoSection {
        case .headerSo, .categorySo:
            return 1
        case .headerPopularSo, .popularSo, .headerNewArrivalSo:
            return (viewModel.selectedCategoryId == Constants.defaultCategoryId) ? 1 : 0
        case .newArrivalSo:
            return (viewModel.selectedCategoryId == Constants.defaultCategoryId) ? viewModel.productData.count : 0
        case .headerForYouSo:
            return (viewModel.selectedCategoryId != Constants.defaultCategoryId) ? 1 : 0
        case .forYouSo:
            return (viewModel.selectedCategoryId != Constants.defaultCategoryId) ? viewModel.productCategorySelectedData.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let homeSoSection = HomeSo(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch homeSoSection {
        case .headerSo:
            return tableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderSoTableViewCell
        case .categorySo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategorySoTableViewCell
            cell.hideSkeleton()
            cell.CategoryData = viewModel.categoryData
            cell.selectedCategoryId = viewModel.selectedCategoryId
            cell.delegate = self
            return cell
        case .headerPopularSo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderForTableViewCell
            cell.configure(title: "Popular")
            return cell
        case .popularSo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PopularSoTableViewCell
            cell.popularData = viewModel.popularData
            cell.productSelectionDelegate = self
            return cell
        case .headerNewArrivalSo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderForTableViewCell
            cell.configure(title: "New Arrival")
            return cell
        case .newArrivalSo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProductSoTableViewCell
            let product = viewModel.productData[indexPath.row]
            configureProductCell(cell, for: product)
            return cell
        case .headerForYouSo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderForTableViewCell
            cell.configure(title: "For You")
            return cell
        case .forYouSo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProductSoTableViewCell
            let product = viewModel.productCategorySelectedData[indexPath.row]
            configureProductCell(cell, for: product)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let homeSection = HomeSo(rawValue: indexPath.section) else {
            return
        }
        
        switch homeSection {
        case .newArrivalSo:
            guard indexPath.row < viewModel.productData.count else {
                return
            }
            let selectedProduct = viewModel.productData[indexPath.row]
            viewModel.handleProductSelection(selectedProduct)
            
        case .forYouSo:
            guard indexPath.row < viewModel.productCategorySelectedData.count else {
                return
            }
            let selectedProduct = viewModel.productCategorySelectedData[indexPath.row]
            viewModel.handleProductSelection(selectedProduct)
            
        default:
            break
        }
    }
    
    internal func configureProductCell(_ cell: ProductSoTableViewCell, for product: ProductModel) {
        if let thirdGalleryURL = product.galleries?.dropFirst(3).first?.url {
            cell.configure(name: product.name, price: "$\(product.price)", imageURL: thirdGalleryURL, category: product.category.name)
        } else {
            let defaultImageURL = Constants.defaultImageURL
            cell.configure(name: product.name, price: "$\(product.price)", imageURL: defaultImageURL, category: product.category.name)
        }
    }
}
