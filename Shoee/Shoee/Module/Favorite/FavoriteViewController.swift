import UIKit
import CoreData

enum favoriteSection {
    case emptyView
    case favoriteView
}

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteTableview: UITableView!

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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteProduct")

        do {
            favoriteData = try managedContext.fetch(fetchRequest)
        } catch {
            print("Error fetching data from CoreData: \(error)")
        }
    }

    private func setupCoreDataObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDataChange(_:)),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: nil)
    }

    @objc private func handleDataChange(_ notification: Notification) {
        fetchData()
        favoriteTableview.reloadData()
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteData.isEmpty ? 1 : favoriteData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favoriteData.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.configure(withImageNamed: "ic_love_nil", message: "Let's find your favorite shoes", title: "You don't have dream shoes?")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
            // Configure the cell with your favorite data using favoriteData[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           if favoriteData.isEmpty {
               return 728.0 // Set the height for the empty cell
           } else {
               return 122.0 // Set the height for the favorite cell
           }
       }
}
