import UIKit
import CoreData

enum Favorite: Int, CaseIterable {
    case empty
    case Favorite
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .empty:
            return EmptyTableViewCell.self
        case .Favorite:
            return FavoriteTableViewCell.self
        }
    }
}

class FavoriteViewController: UIViewController {
    
    @IBOutlet private weak var favoriteTableview: UITableView!
    
    private var favoriteData: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
        setupCoreDataObserver()
    }
    
    private func setupTableView() {
        favoriteTableview.delegate = self
        favoriteTableview.dataSource = self
        
        Favorite.allCases.forEach { cell in
            favoriteTableview.registerCellWithNib(cell.cellTypes)
        }
    }
    
    private func fetchData() {
        let coreDataHelper = CoreDataHelper.shared
        let favoriteDataArray = coreDataHelper.fetchAllData(forEntity: "FavoriteProduct", withPredicate: nil)
        
        favoriteData = favoriteDataArray
    }
    
    private func setupCoreDataObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataChange(_:)),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: nil
        )
    }
    
    @objc private func handleDataChange(_ notification: Notification) {
        fetchData()
        favoriteTableview.reloadData()
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource, EmptyCellDelegate {
    
    func btnAction(inCell cell: EmptyTableViewCell) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
            
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteData.isEmpty ? 1 : favoriteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favoriteData.isEmpty {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as EmptyTableViewCell
            cell.configure(withImageNamed: "ic_love_nil", message: "Let's find your favorite shoes", title: "You don't have dream shoes?")
            cell.delegate = self
            tableView.isScrollEnabled = false
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FavoriteTableViewCell
            
            let favoriteProduct = favoriteData[indexPath.row]
            
            if let name = favoriteProduct.value(forKey: "name") as? String,
               let price = favoriteProduct.value(forKey: "price") as? Double,
               let imageLink = favoriteProduct.value(forKey: "imageLink") as? String {
                
                cell.delegate = self
                cell.configure(name: name, price: "\(price)", imageURLString: imageLink)
            }
            
            favoriteTableview.contentInset.top = 20
            
            return cell
        }
    }
}

extension FavoriteViewController: FavoriteTableViewCellDelegate {
    func favoriteButtonTapped(for cell: FavoriteTableViewCell) {
        
    }
    
    func deleteButtonTapped(for cell: FavoriteTableViewCell) {
        guard let indexPath = favoriteTableview.indexPath(for: cell) else { return }
        
        let deletedObject = favoriteData[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(deletedObject)
        
        do {
            try managedContext.save()
            fetchData()
            favoriteTableview.reloadData()
            let customToast = CustomToast(message: "Has been removed from the Whitelist", backgroundColor: UIColor(named: "Alert")!)
            customToast.showToast(duration: 0.5)
            
        } catch {
           fatalError()
        }
    }
}
