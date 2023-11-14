import UIKit

protocol Sectionable {
	var title: String? { get }
}

enum HomeSetupTable: Int, CaseIterable, Sectionable {
	case header
	case categoryList
	case favoriteCard
	case itemCard
	
	var title: String? {
		switch self {
		case .header, .categoryList, .favoriteCard, .itemCard:
			return nil
		}
	}
}

class HomeViewController: UIViewController {

	@IBOutlet weak var homeSetupLayout: UITableView!

	// Add a property to track whether to show or hide the favoriteCard section
	private var shouldShowFavoriteCard = true
	private var shouldShowItemCard = true

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		homeSetupLayout.reloadData()
	}

	private func setupTableView() {
		homeSetupLayout.delegate = self
		homeSetupLayout.dataSource = self
		homeSetupLayout.isUserInteractionEnabled = true
		homeSetupLayout.register(UINib(nibName: "SetupHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homesetupcellidentifier")
		homeSetupLayout.register(UINib(nibName: "TessTableViewCell", bundle: nil), forCellReuseIdentifier: "tessTableViewCell")
	}
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, SetupHomeCellDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return HomeSetupTable.allCases.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let section = HomeSetupTable(rawValue: indexPath.section) else {
			return UITableViewCell()
		}

		switch section {
		case .header, .categoryList, .favoriteCard, .itemCard:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "homesetupcellidentifier", for: indexPath) as? SetupHomeTableViewCell else {
				return UITableViewCell()
			}

			cell.homeSetupTable = section
			cell.delegate = self

			return cell

		case .itemCard:
			// Use a different cell with "tessTableViewCell" identifier for the additional section
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "tessTableViewCell", for: indexPath) as? TessTableViewCell else {
				return UITableViewCell()
			}

			return cell
		}
	}


	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let section = HomeSetupTable(rawValue: indexPath.section) else {
			return UITableView.automaticDimension
		}

		switch section {
		case .header:
			return 100.0
		case .categoryList:
			return 50.0
		case .favoriteCard:
			return shouldShowFavoriteCard ? 300.0 : 0.0
		case .itemCard:
			return shouldShowItemCard ? 300.0 : 0.0
		}
	}

	// MARK: - SetupHomeCellDelegate

	func didSelectCategory(_ category: Category) {
		if category.id == 6 {
			// Show favoriteCard
			shouldShowFavoriteCard = true
			shouldShowItemCard = true
		} else if category.id == 5 {
			// Hide favoriteCard
			shouldShowFavoriteCard = false
			shouldShowItemCard = false
		} else if category.id == 4 {
			// Hide favoriteCard
			shouldShowFavoriteCard = true
			shouldShowItemCard = false
		}else if category.id == 3 {
			// Hide favoriteCard
			shouldShowFavoriteCard = false
			shouldShowItemCard = true
		}else if category.id == 2 {
			// Hide favoriteCard
			shouldShowFavoriteCard = true
			shouldShowItemCard = false
		}else if category.id == 1 {
			// Hide favoriteCard
			shouldShowFavoriteCard = false
			shouldShowItemCard = false
		}

		// Reload the corresponding section
		let sectionIndex = HomeSetupTable.favoriteCard.rawValue
		homeSetupLayout.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
	}
}
