import UIKit

protocol Sectionable {
	var title: String? { get }
}

enum HomeSetupTable: Int, CaseIterable, Sectionable {
	case header
	case categoryList
	
	var title: String? {
		switch self {
		case .header, .categoryList:
			return nil
		}
	}
}

class HomeViewController: UIViewController, SetupHomeCellDelegate {
	
	@IBOutlet weak var homeSetupLayout: UITableView!
	@IBOutlet weak var customView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		showHomeCustomView()
		setInitialSelection()
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
		homeSetupLayout.register(UINib(nibName: "HeaderTableTableViewCell", bundle: nil), forCellReuseIdentifier: "headerTableTitleCell")
	}
	
	private func showHomeCustomView() {
		let AllShoesTableCustom = ProfileViewController()
		configureCustomView(AllShoesTableCustom)
	}
	
	private func setInitialSelection() {
		let indexPath = IndexPath(row: 0, section: HomeSetupTable.categoryList.rawValue)
		homeSetupLayout.selectRow(at: indexPath, animated: false, scrollPosition: .none)
		tableView(homeSetupLayout, didSelectRowAt: indexPath)
	}
	
	// MARK: - SetupHomeCellDelegate
	
	func didSelectCategory(_ category: Category) {
		switch category.id {
		case 6:
			let homeCustomViewController = ProfileViewController()
			configureCustomView(homeCustomViewController)
			
		case 5:
			let dataCustomViewController = ChatViewController()
			configureCustomView(dataCustomViewController)
			
		default:
			break
		}
	}
	
	
	private func configureCustomView(_ customViewController: UIViewController) {
		// Remove any existing child view controllers
		for childViewController in children {
			childViewController.removeFromParent()
			childViewController.view.removeFromSuperview()
		}
		
		// Add the new child view controller
		addChild(customViewController)
		customViewController.view.frame = customView.bounds
		customViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		customView.addSubview(customViewController.view)
		customViewController.didMove(toParent: self)
	}
	
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "homesetupcellidentifier", for: indexPath) as? SetupHomeTableViewCell else {
			return UITableViewCell()
		}
		
		cell.homeSetupTable = section
		cell.delegate = self
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
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
			
		}
	}
}

