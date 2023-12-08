import UIKit
import CoreData



class CheckOutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , OtherItemCheckOutDetailsCellDelegate{
    
    @IBOutlet weak var checkOutDetailsTableView: UITableView!
    
    var itemList: [Items] = []
    var dataOther: [CheckOut] = []
    var totalPrice: Int16 = 0
    var totalQuantity: Int16 = 0
    let checkOutViewModel = CheckOutViewModel()
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchListitemsFromCoreData()
        fetchCheckOutFromCoreData()
        checkOutDetailsTableView.delegate = self
        checkOutDetailsTableView.dataSource = self
        
        // Register the cell nibs
        checkOutDetailsTableView.register(UINib(nibName: "ListitemsTableViewCell", bundle: nil), forCellReuseIdentifier: "listitemsTableViewCell")
        checkOutDetailsTableView.register(UINib(nibName: "OtherItemCheckOutDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "otherItemCheckOutDetailsTableViewCell")
        
    }
    
    func reloadData () {
        checkOutDetailsTableView.reloadData()
    }
    
    private func fetchListitemsFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Items>(entityName: "Items")
        
        do {
            itemList = try managedContext.fetch(fetchRequest)
            
            totalPrice = Int16(itemList.reduce(0) { $0 + Double($1.price) * Double($1.quantity) })
            totalQuantity = itemList.reduce(0) { $0 + $1.quantity }
            
            checkOutDetailsTableView.reloadData()
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
    }
    
    
    private func fetchCheckOutFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CheckOut>(entityName: "CheckOut")
        
        do {
            dataOther = try managedContext.fetch(fetchRequest)
            checkOutDetailsTableView.reloadData()
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return itemList.count
        case 1:
            return dataOther.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "listitemsTableViewCell", for: indexPath) as! ListitemsTableViewCell
            let item = itemList[indexPath.row]
            let imageURL = URL(string: item.image ?? "") ?? URL(string: "defaultImageURL")!
            cell.configure(withQuantity: Int(item.quantity), price: item.price, productName: item.name ?? "", imageURL: imageURL)
            tableView.contentInset.top = 20
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherItemCheckOutDetailsTableViewCell", for: indexPath) as! OtherItemCheckOutDetailsTableViewCell
            cell.delegate = self
            let data = dataOther[indexPath.row]
            cell.configure(address: data.address ?? "", productQuantity: Int(totalQuantity), productPrice: Double(totalPrice), totalPrice: Double(totalPrice))
            return cell
        default:
            fatalError("Unexpected section")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 130.0
        case 1:
            return 619.0
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    func checkOutButtonTapped(inCell cell: OtherItemCheckOutDetailsTableViewCell) {
        showCustomPIN(with: itemList , dataOther: dataOther)
    }
    
    
    func bcaCheckout() {
        totalPrice = Int16(itemList.reduce(0) { $0 + Double($1.price) * Double($1.quantity) })
        
        let transaction = transactionDetails(orderId: "testing8", grossAmount: Int(totalPrice))
        let bank = bankTransfer(bank: "bca")
        
        let itemDetailsArray = itemList.map { item in
            print("Item: \(item)")
            return itemDetails(id: "\(item.productID)", price: Int(item.price), quantity: Int(item.quantity), name: item.name ?? "")
        }
        
        let customer = customerDetails(email: "test", firstName: "faiz", lastName: "ramadhan", phone: "0822")
        
        checkOutViewModel.performBCACheckout(with: BCAParam(transactionDetails: transaction, bankTransfer: bank, customerDetails: customer, itemDetails: itemDetailsArray))
    }
    
    func postCheckOut(with checkOutParam: CheckOutParam, completion: @escaping ([CheckOutModel]) -> Void) {
        APIManager.shared.makeAPICall(endpoint: .checkout(checkOutParam)) { (result: Result<ResponseCheckOut, Error>) in
            switch result {
            case .success(let responseCheckOut):
                // Update the product data
                
                self.checkOutData = responseCheckOut.data
                // Invoke the closure with the updated data
                completion(responseCheckOut)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
