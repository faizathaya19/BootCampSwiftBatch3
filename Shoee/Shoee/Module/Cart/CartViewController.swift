import UIKit
import CoreData

enum Cart: Int, CaseIterable {
    case empty
    case cart
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .empty:
            return EmptyTableViewCell.self
        case .cart:
            return CartTableViewCell.self
        }
    }
}

class CartViewController: UIViewController {
    
    var cartItems: [Items] = []
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var checkOutBtn: UIButton!
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkOutBtnAction(_ sender: Any) {
        let vC = CheckOutViewController()
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkOutBtn.layer.masksToBounds = true
        checkOutBtn.makeCornerRadius(15)
        cartTableView.delegate = self
        cartTableView.dataSource = self
        Cart.allCases.forEach { cell in
            cartTableView.registerCellWithNib(cell.cellTypes)
        }
        
        fetchDataFromCoreData()
        updateSubTotal()
    }
    
    func deleteItem(productID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
        fetchRequest.predicate = NSPredicate(format: "productID == %ld", productID)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
            
            try managedContext.save()
            
            let customToast = CustomToast(message: "Product removed from the Cart", backgroundColor: UIColor(named: "Alert")!)
            customToast.showToast(duration: 0.5)
            
            fetchDataFromCoreData()
            updateSubTotal()
        } catch {
            print("Error deleting Items from CoreData: \(error)")
        }
    }
    
    private func fetchDataFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Items>(entityName: "Items")
        
        do {
            cartItems = try managedContext.fetch(fetchRequest)
            cartTableView.reloadData()
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
    }
    
    private func updateSubTotal() {
        var subtotal: Double = 0.0
        
        for item in cartItems {
            subtotal += Double(item.quantity) * item.price
        }
        
        subTotal.text = String(format: "$%.2f", subtotal)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate, EmptyCellDelegate {
    
    func btnAction(inCell cell: EmptyTableViewCell) {
        if let navigationController = self.navigationController {
            
            navigationController.popToRootViewController(animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.isEmpty ? 1 : cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cartItems.isEmpty {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as EmptyTableViewCell
            cell.configure(withImageNamed: "ic_cart_nil", message: "Let's find your shoes", title: "Opss! Your Cart is Empty")
            cell.delegate = self
            tableView.isScrollEnabled = false
            tableView.frame.size.height = 727.0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CartTableViewCell
           
            let item = cartItems[indexPath.row]
            let imageURL = URL(string: item.image ?? "") ?? URL(string: "defaultImageURL")!
            cell.configure(withQuantity: Int(item.quantity), price: item.price, productName: item.name ?? "", imageURL: imageURL)
            cell.productID = Int(item.productID)
            cell.delegate = self
            tableView.contentInset.top = 20
            
            return cell
        }
    }
    
    func quantityDidChange(in cell: CartTableViewCell, newQuantity: Int) {
        guard let indexPath = cartTableView.indexPath(for: cell) else {
            return
        }
        
        cartItems[indexPath.row].quantity = Int16(newQuantity)
        saveChangesToCoreData()
        updateSubTotal()
    }
    
    private func saveChangesToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
        } catch {
            print("Error saving to Core Data: \(error)")
        }
    }

    func didDeleteItem(withProductID productID: Int) {
        deleteItem(productID: productID)
    }
}
