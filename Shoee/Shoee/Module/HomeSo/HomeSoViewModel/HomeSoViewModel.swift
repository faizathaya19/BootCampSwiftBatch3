import Foundation
import UIKit

enum HomeSo: Int, CaseIterable {
    case headerSo
    case categorySo
    case headerPopularSo
    case popularSo
    case headerNewArrivalSo
    case newArrivalSo
    case headerForYouSo
    case forYouSo
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .headerSo:
            return HeaderSoTableViewCell.self
        case .categorySo:
            return CategorySoTableViewCell.self
        case .headerPopularSo, .headerNewArrivalSo, .headerForYouSo:
            return HeaderForTableViewCell.self
        case .popularSo:
            return PopularSoTableViewCell.self
        case .newArrivalSo, .forYouSo:
            return ProductSoTableViewCell.self            
        }
    }
}

class HomeSoViewModel {
    var navigationController: UINavigationController?
    
    func setNavigationController(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    var selectedCategoryId: Int? = Constants.defaultCategoryId
    var page = 1
    
    var cachedProductData: [Int: [ProductModel]] = [:]
    var categoryData: [CategoryModel] = []
    var productData: [ProductModel] = []
    var popularData: [ProductModel] = []
    var productCategorySelectedData: [ProductModel] = []
    
    var isLoading: Bool = false
    var hasMoreData: Bool = true
    
    var updateHandler: (() -> Void)?
    
    func fetchData() {
        fetchCategory()
        
        if selectedCategoryId == Constants.defaultCategoryId {
            fetchAllProducts()
        } else {
            fetchProductWithCategory()
        }
    }
    
    func loadMoreData() {
        guard !isLoading, hasMoreData else { return }
        
        isLoading = true
        page += 1
        
        fetchProducts(page: page) { [weak self] in
            self?.isLoading = false
        }
    }
    
    private func fetchAllProducts() {
        fetchProducts(page: page) { [weak self] in
            self?.isLoading = false
        }
        fetchPopular()
    }
    
    private func fetchCategory() {
        CategoryService.shared.getCategories { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.categoryData = categories.reversed()
                self.updateHandler?()
            case .failure(let error):
                self.showFetchError(error)
            }
        }
    }
    
    private func fetchProducts(page: Int, completion: @escaping () -> Void) {
        ProductsService.shared.performProduct(with: ProductParam(limit: 4, page: page)) { [weak self] newData in
            guard let self = self else { return }
            self.productData.append(contentsOf: newData)
            self.updateHandler?()
            completion()
        }
    }
    
    private func fetchPopular() {
        guard popularData.isEmpty else { return }
        
        ProductsService.shared.performProduct(with: ProductParam(tags: "popular")) { [weak self] newData in
            self?.popularData.append(contentsOf: newData)
            self?.updateHandler?()
        }
    }
    
    private func fetchProductWithCategory() {
        guard let categoryId = selectedCategoryId else { return }
        
        if let cachedData = cachedProductData[categoryId] {
            self.productCategorySelectedData = cachedData
            updateHandler?()
        } else {
            ProductsService.shared.performProduct(with: ProductParam(categories: categoryId)) { [weak self] newData in
                self?.cachedProductData[categoryId] = newData
                self?.productCategorySelectedData.removeAll()
                self?.productCategorySelectedData.append(contentsOf: newData)
                self?.updateHandler?()
            }
        }
    }
    
    private func showFetchError(_ error: Error) {
        print("Failed to fetch data: \(error.localizedDescription)")
    }
    
    internal func handleProductSelection(_ product: ProductModel) {
        let detailViewController = DetailProductViewController(productID: product.id)
        detailViewController.product = product
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: false)
    }
}
