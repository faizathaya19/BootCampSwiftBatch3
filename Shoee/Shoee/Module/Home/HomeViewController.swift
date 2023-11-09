import UIKit

enum HomeSetupTable: Int, CaseIterable {
    case header
    case categoryList
    case popularProd
    case newArrival
    
    var title: String {
        switch self {
        case .header, .categoryList:
            return ""
        case .popularProd:
            return "Popular Products"
        case .newArrival:
            return "New Arrivals"
        }
    }
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeSetupLayout: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        homeSetupLayout.delegate = self
        homeSetupLayout.dataSource = self
        homeSetupLayout.register(UINib(nibName: "SetupHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homesetupcellidentifier")
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
        let cellIdentifier = "homesetupcellidentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SetupHomeTableViewCell
        
        guard let section = HomeSetupTable(rawValue: indexPath.section) else {
            return cell // Handle the case when the section is not found
        }
        
        switch section {
        case .header:
            // Configure cell for header section
            cell.title.text = "Header Section"
            // Add any additional configuration specific to the header section
        case .categoryList:
            // Configure cell for category list section
            cell.title.text = "Category List Section"
            // Add any additional configuration specific to the category list section
        case .popularProd:
            // Configure cell for popular products section
            cell.title.text = "Popular Products Section"
            // Add any additional configuration specific to the popular products section
        case .newArrival:
            // Configure cell for new arrivals section
            cell.title.text = "New Arrivals Section"
            // Add any additional configuration specific to the new arrivals section
        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = HomeSetupTable(rawValue: indexPath.section) else {
            return UITableView.automaticDimension // Handle the case when the section is not found
        }

        switch section {
        case .header, .categoryList, .popularProd:
            return 230.0
        case .newArrival:
            return 170.0
        }
    }
}
