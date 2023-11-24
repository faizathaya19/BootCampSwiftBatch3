import UIKit
import SkeletonView

enum HomeSetupTable: Int, CaseIterable {
	case header
	case categoryList
	case popularProduct
	case newArrival
	case forYouProduct
}

class HomeViewController: UIViewController {
	
	@IBOutlet weak var homeSetupLayout: UITableView!
	
	var newArrivalData: [ProductModel] = [] {
		didSet {
			reloadAndHideSkeleton()
		}
	}
	
	var forYouData: [ProductModel] = [] {
		didSet {
			reloadAndHideSkeleton()
		}
	}
	
	var selectedCategory: CategoryModel?
	var setupHomeTableViewCell: SetupHomeTableViewCell?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		fetchProducts(for: .newArrival)
		
		if let defaultCategory = getCategoryById(6) {
			selectedCategory = defaultCategory
			setupHomeTableViewCell?.selectedCategoryIndex = selectedCategory?.id
			homeSetupLayout.reloadData()
			fetchProducts(for: .forYouProduct)
		}
	}
	
	private func reloadAndHideSkeleton() {
		homeSetupLayout.reloadData()
		homeSetupLayout.hideSkeleton()
	}
	
	private func fetchProducts(for section: HomeSetupTable) {
		homeSetupLayout.showAnimatedGradientSkeleton()
		
		switch section {
		case .newArrival:
			fetchNewArrivalProducts()
		case .forYouProduct:
			fetchProductsForSelectedCategory()
		default:
			break
		}
	}
	
	private func fetchNewArrivalProducts() {
		ProductsService.shared.getProducts(limit: 0) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let products):
				self.newArrivalData = products
			case .failure(let error):
				print("Failed to fetch new arrival products: \(error.localizedDescription)")
			}
			self.reloadAndHideSkeleton()
		}
	}
	
	private func fetchProductsForSelectedCategory() {
		guard let categoryId = selectedCategory?.id else { return }
		ProductsService.shared.getProducts(categories: categoryId) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let products):
				self.forYouData = products
			case .failure(let error):
				print("Failed to fetch products for selected category: \(error.localizedDescription)")
			}
			self.reloadAndHideSkeleton()
		}
	}
	
	private func setupTableView() {
		homeSetupLayout.delegate = self
		homeSetupLayout.dataSource = self
		homeSetupLayout.isUserInteractionEnabled = true
		homeSetupLayout.register(UINib(nibName: "SetupHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homesetupcellidentifier")
		homeSetupLayout.register(UINib(nibName: "PopularProductTableViewCell", bundle: nil), forCellReuseIdentifier: "popularProductCellIdentifier")
		homeSetupLayout.register(UINib(nibName: "NewArrivalTableViewCell", bundle: nil), forCellReuseIdentifier: "newArrivalCellIdentifier")
		homeSetupLayout.register(UINib(nibName: "ForYouProductTableViewCell", bundle: nil), forCellReuseIdentifier: "forYouProductCellIdentifier")
		
		if let cell = homeSetupLayout.dequeueReusableCell(withIdentifier: "homesetupcellidentifier") as? SetupHomeTableViewCell {
			cell.delegate = self
			cell.homeSetupTable = .categoryList
			cell.fetchCategories()
			setupHomeTableViewCell = cell
		}
	}
	
	private func getCategoryById(_ categoryId: Int) -> CategoryModel? {
		return setupHomeTableViewCell?.categoryList.first { $0.id == categoryId }
	}
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return HomeSetupTable.allCases.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let homeSection = HomeSetupTable(rawValue: section) else {
			return 0
		}
		
		switch homeSection {
		case .header, .categoryList:
			return 1
		case .popularProduct:
			return shouldShowSection(homeSection) ? 1 : 0
		case .forYouProduct:
			return shouldShowSection(homeSection) ? forYouData.count : 0
		case .newArrival:
			return shouldShowSection(homeSection) ? newArrivalData.count : 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let homeSection = HomeSetupTable(rawValue: indexPath.section) else {
			return UITableViewCell()
		}
		
		switch homeSection {
		case .header, .categoryList:
			return setupHomeTableViewCell(for: homeSection, indexPath: indexPath)
		case .popularProduct:
			return popularProductCell(for: indexPath)
		case .newArrival:
			return newArrivalCell(for: indexPath)
		case .forYouProduct:
			return forYouProductCell(for: indexPath)
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let homeSection = HomeSetupTable(rawValue: indexPath.section) else {
			return
		}
		
		switch homeSection {
		case .newArrival:
			handleProductSelection(for: newArrivalData, at: indexPath)
		case .forYouProduct:
			handleProductSelection(for: forYouData, at: indexPath)
		default:
			break
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let homeSection = HomeSetupTable(rawValue: indexPath.section) else {
			return UITableView.automaticDimension
		}
		
		switch homeSection {
		case .header:
			return 80.0
		case .categoryList:
			return 70.0
		case .popularProduct, .forYouProduct, .newArrival:
			return UITableView.automaticDimension
		}
	}
	
	// MARK: - Private Methods
	
	private func setupHomeTableViewCell(for section: HomeSetupTable, indexPath: IndexPath) -> UITableViewCell {
		let cell = homeSetupLayout.dequeueReusableCell(withIdentifier: "homesetupcellidentifier", for: indexPath) as! SetupHomeTableViewCell
		cell.delegate = self
		cell.homeSetupTable = section
		cell.selectedCategoryIndex = selectedCategory?.id
		return cell
	}

	private func popularProductCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = homeSetupLayout.dequeueReusableCell(withIdentifier: "popularProductCellIdentifier", for: indexPath) as! PopularProductTableViewCell
		cell.configure(withTitle: "Popular Products", title2: "New Arrivals")
		cell.navigationController = self.navigationController
		return cell
	}

	private func newArrivalCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = homeSetupLayout.dequeueReusableCell(withIdentifier: "newArrivalCellIdentifier", for: indexPath) as! NewArrivalTableViewCell
		let product = newArrivalData[indexPath.row]

		if let thirdGallery = product.galleries?.dropFirst(3).first {
			let thirdGalleryURL = thirdGallery.url
			cell.configure(name: product.name, price: "$\(product.price)", imageURL: thirdGalleryURL, category: product.category.name)
		} else {
			cell.configure(name: product.name, price: "$\(product.price)", imageURL: "https://static.vecteezy.com/system/resources/thumbnails/007/872/974/small/file-not-found-illustration-with-confused-people-holding-big-magnifier-search-no-result-data-not-found-concept-can-be-used-for-website-landing-page-animation-etc-vector.jpg", category: product.category.name)
		}

		return cell
	}

	private func forYouProductCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = homeSetupLayout.dequeueReusableCell(withIdentifier: "forYouProductCellIdentifier", for: indexPath) as! ForYouProductTableViewCell
		let product = forYouData[indexPath.row]

		if let thirdGallery = product.galleries?.dropFirst(3).first {
			let thirdGalleryURL = thirdGallery.url
			cell.configure(name: product.name, price: "$\(product.price)", imageURL: thirdGalleryURL, category: product.category.name)
		} else {
			cell.configure(name: product.name, price: "$\(product.price)", imageURL: "https://static.vecteezy.com/system/resources/thumbnails/007/872/974/small/file-not-found-illustration-with-confused-people-holding-big-magnifier-search-no-result-data-not-found-concept-can-be-used-for-website-landing-page-animation-etc-vector.jpg", category: product.category.name)
		}

		return cell
	}


	private func handleProductSelection(for products: [ProductModel], at indexPath: IndexPath) {
		guard indexPath.item < products.count else {
			return
		}

		let selectedProduct = products[indexPath.item]
		let detailViewController = DetailProductViewController(productID: selectedProduct.id)
		detailViewController.product = selectedProduct
		detailViewController.hidesBottomBarWhenPushed = true
		navigationController?.pushViewController(detailViewController, animated: false)
	}
	
	private func shouldShowSection(_ section: HomeSetupTable) -> Bool {
		guard let selectedCategory = selectedCategory else {
			return false
		}
		
		switch section {
		case .popularProduct, .newArrival:
			return selectedCategory.id == 6
		case .forYouProduct:
			return selectedCategory.id >= 1 && selectedCategory.id <= 5
		default:
			return true
		}
	}
}

extension HomeViewController: SetupHomeCellDelegate {
	func didSelectCategory(_ category: CategoryModel) {
		selectedCategory = category
		homeSetupLayout.reloadData()
		fetchProducts(for: .forYouProduct)
	}
}
