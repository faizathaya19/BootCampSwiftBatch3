import UIKit

enum HomeSo: Int, CaseIterable {
    case header
    case category
    case popular
    case newArrival
    case forYou
}

class HomeSoViewController: UIViewController {
    
    @IBOutlet weak var homeSotableView: UITableView!
    
    var selectedCategoryIndex: Int = -1
    
    var categoryList: [CategoryModel] = []
    
    var categories: [Categoryy] = [
        Categoryy(id: 1, name: "Category 1"),
        Categoryy(id: 2, name: "Category 2"),
        Categoryy(id: 3, name: "Category 3"),
        Categoryy(id: 4, name: "Category 3"),
        Categoryy(id: 5, name: "Category 3"),
        Categoryy(id: 6, name: "Category 3"),
        // ... tambahkan kategori lainnya sesuai kebutuhan
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeSotableView.delegate = self
        homeSotableView.dataSource = self
        homeSotableView.register(UINib(nibName: "HeaderSoTableViewCell", bundle: nil), forCellReuseIdentifier: "headerSoTableViewCell")
        homeSotableView.register(UINib(nibName: "CategorySoTableViewCell", bundle: nil), forCellReuseIdentifier: "categorySoTableViewCell")
        homeSotableView.register(UINib(nibName: "PopularSoTableViewCell", bundle: nil), forCellReuseIdentifier: "popularSoTableViewCell")
        homeSotableView.register(UINib(nibName: "productSoTableViewCell", bundle: nil), forCellReuseIdentifier: "productSoTableViewCell")
        
        homeSotableView.separatorStyle = .none
    }
}

extension HomeSoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSo.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let homeSo = HomeSo(rawValue: section) else {
            return 0
        }
        
        switch homeSo {
        case .header:
            return 1
        case .category:
            return 1
        case .popular:
            return 1
        case .newArrival:
            return 9
        case .forYou:
            return 9
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let homeSo = HomeSo(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch homeSo {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerSoTableViewCell", for: indexPath) as! HeaderSoTableViewCell
            // Configure cell
            
            return cell
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: "categorySoTableViewCell", for: indexPath) as! CategorySoTableViewCell
            cell.categories = categories
            
            return cell
        case .popular:
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularSoTableViewCell", for: indexPath) as! PopularSoTableViewCell
            // Configure cell
            
            return cell
        case .newArrival:
            let cell = tableView.dequeueReusableCell(withIdentifier: "productSoTableViewCell", for: indexPath) as! ProductSoTableViewCell
            // Configure cell
            
            return cell
        case .forYou:
            let cell = tableView.dequeueReusableCell(withIdentifier: "productSoTableViewCell", for: indexPath) as! ProductSoTableViewCell
            // Configure cell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let homeSo = HomeSo(rawValue: section) else {
            return nil
        }
        
        switch homeSo {
        case .popular:
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            
            let titleLabel = UILabel()
            titleLabel.text = "Popular"
            titleLabel.textColor = UIColor(named:"PrimaryText")
            titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 19)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            headerView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            ])
            
            return headerView
        case .newArrival:
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            
            let titleLabel = UILabel()
            titleLabel.text = "New Arrival"
            titleLabel.textColor = UIColor(named:"PrimaryText")
            titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 19)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            headerView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            ])
            
            return headerView
            
        case .forYou:
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            
            let titleLabel = UILabel()
            titleLabel.text = "For You"
            titleLabel.textColor = UIColor(named:"PrimaryText")
            titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 19)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            headerView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            ])
            
            return headerView
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let homeSo = HomeSo(rawValue: section) else {
            return 0
        }
        
        switch homeSo {
        case .popular, .newArrival, .forYou:
            return 40
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
