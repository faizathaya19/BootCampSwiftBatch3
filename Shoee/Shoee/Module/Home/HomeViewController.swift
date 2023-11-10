import UIKit

protocol Sectionable {
    var title: String? { get }
}

enum HomeSetupTable: Int, CaseIterable, Sectionable {
    case header
    case categoryList
    case popularProd
    case newArrival
    
    var title: String? {
        switch self {
        case .header, .categoryList:
            return nil
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeSetupLayout.reloadData()
        setupTableView()
    }
    
    private func setupTableView() {
        homeSetupLayout.delegate = self
        homeSetupLayout.dataSource = self
        homeSetupLayout.isUserInteractionEnabled = true
        homeSetupLayout.register(UINib(nibName: "SetupHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homesetupcellidentifier")
        homeSetupLayout.register(UINib(nibName: "HeaderTableTableViewCell", bundle: nil), forCellReuseIdentifier: "headerTableTitleCell")
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
        
        let cellIdentifier: String
        let cellType: HomeSetupTable
        
        switch section {
        case .header:
            cellType = .header
        case .categoryList:
            
            cellType = .categoryList
        case .popularProd:
            
            cellType = .popularProd
        case .newArrival:
            
            cellType = .newArrival
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homesetupcellidentifier", for: indexPath) as? SetupHomeTableViewCell else {
            return UITableViewCell()
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = HomeSetupTable(rawValue: indexPath.section) else { return }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = HomeSetupTable(rawValue: indexPath.section) else {
            return UITableView.automaticDimension // Handle the case when the section is not found
        }
        
        switch section {
        case .header, .categoryList, .popularProd:
            return 90.0
        case .newArrival:
            return 170.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let homeSetupTable = HomeSetupTable(rawValue: section),
              homeSetupTable == .popularProd || homeSetupTable == .newArrival else {
            return nil
        }

        let headerTitle = Bundle.main.loadNibNamed("HeaderTableTableViewCell", owner: self, options: nil)?.first as! HeaderTableTableViewCell
        headerTitle.titleHeaderTable.text = homeSetupTable.title
        return headerTitle
    }


}
