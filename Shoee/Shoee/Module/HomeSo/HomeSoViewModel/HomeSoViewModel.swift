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

protocol HomeSoViewModelDelegate: AnyObject {
    func didFailFetch()
    func ifNewUser()
    func reloadData()
}

class HomeSoViewModel {
    var navigationController: UINavigationController?
    
    weak var delegate: HomeSoViewModelDelegate?
    
    var selectedCategoryId: Int? = Constants.defaultCategoryId
    var page = 1
    
    var cachedProductData: [Int: [ProductModel]] = [:]
    var categoryData: [CategoryModel] = []
    var productData: [ProductModel] = []
    var responseProduct: [ResponseProductModel] = []
    var popularData: [ProductModel] = []
    var userData: [UserModel] = []
    var productCategorySelectedData: [ProductModel] = []
    let userId = UserDefaultManager.getUserID()
    
    var isLoading: Bool = false
    var hasMoreData: Bool = true
    
    private let dataFetchGroup = DispatchGroup()
    
    func setNavigationController(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func fetchFirst() {
        dataFetchGroup.enter()
        fetchUsers()
        
        dataFetchGroup.enter()
        fetchCategory()
        
        dataFetchGroup.enter()
        fetchAllProducts()
        
        
        dataFetchGroup.notify(queue: .main) { [weak self] in
            self?.updateHandler()
        }
    }
    
    func fetchData() {
        fetchProductWithCategory()
    }
    
    func loadMoreData() {
        guard !isLoading, hasMoreData else { return }
        
        isLoading = true
        page += 1
        self.isLoading = false
        
        fetchProducts(page: page) { [weak self] in
            self?.isLoading = false
        }
        self.isLoading = false
    }
    
    private func fetchAllProducts() {
        fetchProducts(page: page) { [weak self] in
            self?.isLoading = false
            self?.dataFetchGroup.leave()
        }
        fetchPopular()
    }
    
    private func fetchCategory() {
        APIManager.shared.makeAPICall(endpoint: .categories) { (result: Result<ResponseCategoryModel, Error>) in
            
            self.dataFetchGroup.leave()
            
            switch result {
            case .success(let categories):
                self.categoryData = categories.data.data.reversed()
                self.updateHandler()
            case .failure(_):
                self.showFetchError()
            }
        }
    }
    
    
    private func performProduct(with productParam: ProductParam, completion: @escaping ([ProductModel]) -> Void) {
        APIManager.shared.makeAPICall(endpoint: .products(productParam)) { (result: Result<ResponseProductModel, Error>) in
            switch result {
            case .success(let responseProduct):
                let newData = responseProduct.data.data
                self.responseProduct = [responseProduct]
                
                completion(newData)
            case .failure(_):
                self.showFetchError()
            }
        }
    }
    
    func checkNewUser() {
        let predicate = NSPredicate(format: "userId == %ld", userId!)
        
        let isDataExists = CoreDataHelper.shared.isDataExistsInCoreData(forEntity: "User", withPredicate: predicate)
        
        if !isDataExists {
            self.delegate?.ifNewUser()
        }
    }
    
    
    private func fetchProducts(page: Int, completion: @escaping () -> Void) {
        performProduct(with: ProductParam(limit: 4, page: page)) { [weak self] newData in
            guard let self = self else { return }
            self.productData.append(contentsOf: newData)
            self.updateHandler()
            completion()
        }
    }
    
    private func fetchUsers() {
        APIManager.shared.makeAPICall(endpoint: .user) { [weak self] (result: Result<ResponseUserModel, Error>) in
            
            self?.dataFetchGroup.leave()
            
            switch result {
            case .success(let response):
                self?.userData = [response.data]
                self?.updateHandler()
            case .failure(_):
                self?.showFetchError()
            }
            
        }
    }
    
    private func fetchPopular() {
        guard popularData.isEmpty else { return }
        
        performProduct(with: ProductParam(tags: "popular")) { [weak self] newData in
            self?.popularData.append(contentsOf: newData)
            self?.updateHandler()
        }
    }
    
    private func fetchProductWithCategory() {
        guard let categoryId = selectedCategoryId else { return }
        
        if let cachedData = cachedProductData[categoryId] {
            self.productCategorySelectedData = cachedData
            updateHandler()
        } else {
            performProduct(with: ProductParam(categories: categoryId)) { [weak self] newData in
                self?.cachedProductData[categoryId] = newData
                self?.productCategorySelectedData.removeAll()
                self?.productCategorySelectedData.append(contentsOf: newData)
                self?.updateHandler()
            }
        }
    }
    
    private func updateHandler() {
        self.delegate?.reloadData()
    }
    
    private func showFetchError() {
        self.delegate?.didFailFetch()
    }
    
    internal func handleProductSelection(_ product: ProductModel) {
        let detailViewController = DetailProductViewController(productID: product.id)
        detailViewController.product = product
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: false)
    }
}
