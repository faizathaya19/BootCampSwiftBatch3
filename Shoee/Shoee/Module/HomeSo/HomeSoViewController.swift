import UIKit

enum HomeSo: Int, CaseIterable {
    case headerSo
    case categorySo
    case popularSo
    case newArrivalSo
    case forYouSo
    case pageControllSo
}

class HomeSoViewController: UIViewController {

    @IBOutlet private weak var homeSoTableView: UITableView!

    private var selectedCategoryId: Int? = 6
    
    var ProductData: [ProductModel] = [] {
        didSet {
            homeSoTableView.reloadData()
        }
    }
    
    var CategoryData: [CategoryModel] = [] {
        didSet {
            homeSoTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchProducts()
        fetchCategory()
        selectedCategoryId = CategoryData.first?.id
    }
    
    func fetchCategory() {
        CategoryService.shared.getCategories { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let categories):
                self.CategoryData = categories.reversed()
            case .failure(let error):
                print("Failed to fetch categories: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchProducts() {

        ProductsService.shared.getProducts(limit: 0) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let products):
                self.ProductData = products
            case .failure(let error):
                print("Failed to fetch new arrival products: \(error.localizedDescription)")

               
            }
        }
    }

    private func setupTableView() {
        homeSoTableView.delegate = self
        homeSoTableView.dataSource = self
        homeSoTableView.register(UINib(nibName: "HeaderSoTableViewCell", bundle: nil), forCellReuseIdentifier: "headerSoTableViewCell")
        homeSoTableView.register(UINib(nibName: "CategorySoTableViewCell", bundle: nil), forCellReuseIdentifier: "categorySoTableViewCell")
        homeSoTableView.register(UINib(nibName: "PopularSoTableViewCell", bundle: nil), forCellReuseIdentifier: "popularSoTableViewCell")
        homeSoTableView.register(UINib(nibName: "ProductSoTableViewCell", bundle: nil), forCellReuseIdentifier: "productSoTableViewCell")
        homeSoTableView.register(UINib(nibName: "PageControllSoTableViewCell", bundle: nil), forCellReuseIdentifier: "pageControllSoTableViewCell")
        
        homeSoTableView.rowHeight = UITableView.automaticDimension
    }
}

extension HomeSoViewController: UITableViewDelegate, UITableViewDataSource, CategorySoDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSo.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let homeSoSection = HomeSo(rawValue: section) else {
            return 0
        }

        switch homeSoSection {
        case .headerSo, .categorySo :
            return 1
        case .popularSo, .pageControllSo:
            return (selectedCategoryId == 6) ? 1 : 0
        case .forYouSo:
            return (selectedCategoryId != 6) ? ProductData.filter { $0.categoriesId == selectedCategoryId }.count : 0
        case .newArrivalSo:
            return (selectedCategoryId == 6) ? ProductData.count : 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let homeSoSection = HomeSo(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch homeSoSection {
        case .headerSo:
            return configureHeaderCell(for: indexPath)
        case .categorySo:
            return configureCategoryCell(for: indexPath)
        case .popularSo:
            return configurePopularCell(for: indexPath)
        case .newArrivalSo:
            return configureNewArrivalCell(for: indexPath)
        case .forYouSo:
            return configureForYouCell(for: indexPath)
        case .pageControllSo:
            return configurePageControllCell(for: indexPath)
        }
    }

    private func configureHeaderCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = homeSoTableView.dequeueReusableCell(withIdentifier: "headerSoTableViewCell", for: indexPath) as! HeaderSoTableViewCell
        // Configure cell headerSo
        return cell
    }

    private func configureCategoryCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = homeSoTableView.dequeueReusableCell(withIdentifier: "categorySoTableViewCell", for: indexPath) as! CategorySoTableViewCell
        cell.CategoryData = CategoryData
        cell.selectedCategoryId = selectedCategoryId
        cell.delegate = self
        return cell
    }

    private func configurePopularCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = homeSoTableView.dequeueReusableCell(withIdentifier: "popularSoTableViewCell", for: indexPath) as! PopularSoTableViewCell
        return cell
    }

    private func configureNewArrivalCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = homeSoTableView.dequeueReusableCell(withIdentifier: "productSoTableViewCell", for: indexPath) as! ProductSoTableViewCell
        let product = ProductData[indexPath.row]
        if let thirdGallery = product.galleries?.dropFirst(3).first {
            let thirdGalleryURL = thirdGallery.url
            cell.configure(name: product.name, price: "$\(product.price)", imageURL: thirdGalleryURL, category: product.category.name)
        } else {
            cell.configure(name: product.name, price: "$\(product.price)", imageURL: "https://static.vecteezy.com/system/resources/thumbnails/007/872/974/small/file-not-found-illustration-with-confused-people-holding-big-magnifier-search-no-result-data-not-found-concept-can-be-used-for-website-landing-page-animation-etc-vector.jpg", category: product.category.name)
        }

        return cell
    }

    private func configureForYouCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = homeSoTableView.dequeueReusableCell(withIdentifier: "productSoTableViewCell", for: indexPath) as! ProductSoTableViewCell

        let filteredProducts = ProductData.filter { $0.categoriesId == selectedCategoryId }

        guard indexPath.row < filteredProducts.count else {
            return UITableViewCell()
        }

        let product = filteredProducts[indexPath.row]

        if let thirdGallery = product.galleries?.dropFirst(3).first {
            let thirdGalleryURL = thirdGallery.url
            cell.configure(name: product.name, price: "$\(product.price)", imageURL: thirdGalleryURL, category: product.category.name)
        } else {
            cell.configure(name: product.name, price: "$\(product.price)", imageURL: "https://static.vecteezy.com/system/resources/thumbnails/007/872/974/small/file-not-found-illustration-with-confused-people-holding-big-magnifier-search-no-result-data-not-found-concept-can-be-used-for-website-landing-page-animation-etc-vector.jpg", category: product.category.name)
        }

        return cell
    }
    
    private func configurePageControllCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = homeSoTableView.dequeueReusableCell(withIdentifier: "pageControllSoTableViewCell", for: indexPath) as! PageControllSoTableViewCell
        // Configure cell headerSo
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = HomeSo(rawValue: section) else {
            return nil
        }

        let headerView = CustomHeaderView()

        switch sectionType {
        case .popularSo:
            headerView.setTitle((selectedCategoryId == 6) ? "Popular Section" : "")
        case .newArrivalSo:
            headerView.setTitle((selectedCategoryId == 6) ? "New Arrival Section" : "")
        case .forYouSo:
            headerView.setTitle((selectedCategoryId != 6) ? "For You Section" : "")
        default:
            return nil
        }

        return headerView
    }

    func didSelectCategory(withId categoryId: Int) {
        selectedCategoryId = categoryId
        print("Selected category ID: \(categoryId)")

        fetchProducts()
        homeSoTableView.reloadData()
    }
    
    
}
