import UIKit
import SkeletonView

protocol Sectionable {
	var title: String? { get }
}

enum HomeSetupTable: Int, CaseIterable, Sectionable {
	case header
	case categoryList
	case popularProduct
	case newArrival
	case forYouProduct

	var title: String? {
		switch self {
		case .header, .categoryList, .popularProduct, .newArrival, .forYouProduct:
			return nil
		}
	}
}

class HomeViewController: UIViewController {

	@IBOutlet weak var homeSetupLayout: UITableView!

	var newArrivalData: [ProductModel] = [] {
		didSet {
			homeSetupLayout.reloadData()
		}
	}

	var selectedCategory: CategoryModel?
	var setupHomeTableViewCell: SetupHomeTableViewCell?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		fetchProducts()

		// Automatically select a default category and update the view
		if let defaultCategory = getCategoryById(6) {
			selectedCategory = defaultCategory
			setupHomeTableViewCell?.selectedCategoryIndex = selectedCategory?.id
			homeSetupLayout.reloadData()
		}
	}

	private func fetchProducts() {
		homeSetupLayout.showAnimatedGradientSkeleton()
		ProductsService.shared.getProducts { [weak self] result in
			guard let self = self else { return }

			switch result {
			case .success(let products):
				print("Received popular products from API: \(products)")
				self.newArrivalData = products
				self.homeSetupLayout.hideSkeleton()
			case .failure(let error):
				print("Failed to fetch popular products: \(error.localizedDescription)")
				self.homeSetupLayout.hideSkeleton()
			}
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
			return shouldShowSection(homeSection) ? newArrivalData.count : 0
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
			let cell = tableView.dequeueReusableCell(withIdentifier: "homesetupcellidentifier", for: indexPath) as! SetupHomeTableViewCell
			cell.delegate = self
			cell.homeSetupTable = homeSection
			cell.selectedCategoryIndex = selectedCategory?.id
			return cell
		case .popularProduct:
			let cell = tableView.dequeueReusableCell(withIdentifier: "popularProductCellIdentifier", for: indexPath) as! PopularProductTableViewCell
			cell.configure(withTitle: "Popular Products", title2: "New Arrivals")
			cell.navigationController = self.navigationController
			return cell
		case .newArrival:
			let cell = tableView.dequeueReusableCell(withIdentifier: "newArrivalCellIdentifier", for: indexPath) as! NewArrivalTableViewCell
			let product = newArrivalData[indexPath.row]
			if let thirdGallery = product.galleries?.dropFirst(3).first {
				let thirdGalleryURL = thirdGallery.url
			cell.configure(name: product.name, price: "$\(product.price)", imageURL: thirdGalleryURL, category: product.category.name)
			} else {
				cell.configure(name: product.name, price: "$\(product.price)", imageURL: "", category: product.category.name)
				
			}
			return cell

		case .forYouProduct:
			let cell = tableView.dequeueReusableCell(withIdentifier: "forYouProductCellIdentifier", for: indexPath) as! ForYouProductTableViewCell
			
			let product = newArrivalData[indexPath.row]
			if let thirdGallery = product.galleries?.dropFirst(3).first {
				let thirdGalleryURL = thirdGallery.url
			cell.configure(name: product.name, price: "$\(product.price)", imageURL: thirdGalleryURL, category: product.category.name)
			} else {
				cell.configure(name: product.name, price: "$\(product.price)", imageURL: "", category: product.category.name)
				
			}
			return cell
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
	}
}
