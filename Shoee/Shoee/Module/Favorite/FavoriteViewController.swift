import UIKit
import CoreData

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
        favoriteTableview.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyTableViewCell")
        favoriteTableview.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoriteTableViewCell")
    }

    private func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteProduct")

        do {
            favoriteData = try managedContext.fetch(fetchRequest)
        } catch {
            print("Error fetching data from CoreData: \(error.localizedDescription)")
        }
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteData.isEmpty ? 1 : favoriteData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favoriteData.isEmpty {
            // Configure the empty cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.configure(withImageNamed: "ic_love_nil", message: "Let's find your favorite shoes", title: "You don't have dream shoes?")

            // Disable scrolling for emptyTableViewCell
            tableView.isScrollEnabled = false

            return cell
        } else {
            // Configure the favorite product cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell

            let favoriteProduct = favoriteData[indexPath.row]
            
            // Assuming your Core Data entity has attributes "name", "price", and "imageLink"
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


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return favoriteData.isEmpty ? 728 : 130.0
    }
}

// MARK: - FavoriteTableViewCellDelegate
extension FavoriteViewController: FavoriteTableViewCellDelegate {
    func favoriteButtonTapped(for cell: FavoriteTableViewCell) {
        // Handle favorite button tap if needed
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
            showCustomSlideMess(message: "Has been removed from the Whitelist", color: UIColor(named: "Alert")!)
        
        } catch {
            print("Error deleting data from CoreData: \(error.localizedDescription)")
        }
    }
}

// MARK: - UITableView Extension
extension UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: cellType)
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type, configure: (T) -> Void) -> T {
        let identifier = String(describing: cellType)
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
        configure(cell)
        return cell
    }
}
