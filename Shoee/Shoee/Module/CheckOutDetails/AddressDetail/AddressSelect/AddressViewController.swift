import UIKit
import CoreData

enum Address: Int, CaseIterable {
    case newAddress
    case listAddress
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .newAddress:
            return AddNewAddressTableViewCell.self
        case .listAddress:
            return AddressTableViewCell.self
        }
    }
}


protocol SelectAddressDelegate: AnyObject {
    func didSelectAddress()
}

class AddressViewController: UIViewController, AddNewAddressCellDelegate {
    weak var delegate: SelectAddressDelegate?
    let userId = UserDefaultManager.getUserID()
    @IBOutlet weak var addressTableView: UITableView!
    
    @IBAction func addNewAddress(_ sender: Any) {
        addNewAddress.toggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               let section = Address.newAddress.rawValue
               let row = 0
               let indexPath = IndexPath(row: row, section: section)

               // Check if the section and row are valid before scrolling
               if section < self.addressTableView.numberOfSections, row < self.addressTableView.numberOfRows(inSection: section) {
                   self.addressTableView.scrollToRow(at: indexPath, at: .top, animated: false)
               }
           }
        
        addressTableView.reloadData()
    }

    
    var addNewAddress: Bool = false
    let coreDataHelper = CoreDataHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    private func registerCells() {
        addressTableView.dataSource = self
        addressTableView.delegate = self
        
        Address.allCases.forEach { cell in
            addressTableView.registerCellWithNib(cell.cellTypes)
        }
    }
    
    func didTapAddNewAddress(_ addressText: String) {
        
        let data = ["userID": userId as Any, "address": addressText] as [String : Any]
        coreDataHelper.saveDataToCoreData(entityName: "AddressList", data: data)
        
        addNewAddress = false
        
        if let addNewAddressCell = addressTableView.cellForRow(at: IndexPath(row: 0, section: Address.newAddress.rawValue)) as? AddNewAddressTableViewCell {
            addNewAddressCell.messageTextView.text = ""
        }
        
        addressTableView.reloadData()
    }
    
}

extension AddressViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Address.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let addressSection = Address(rawValue: section) else {
            return 0
        }
        
        switch addressSection {
        case .newAddress:
            let predicate = NSPredicate(format: "userID == %@", NSNumber(value: userId!))
            let addresses = coreDataHelper.fetchFromCoreData(forEntity: "AddressList", withPredicate: predicate)
            return addresses.isEmpty || addNewAddress ? 1 : 0
        case .listAddress:
            let predicate = NSPredicate(format: "userID == %@", NSNumber(value: userId!))
            let addresses = coreDataHelper.fetchFromCoreData(forEntity: "AddressList", withPredicate: predicate)
            return addresses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addressSection = Address(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch addressSection {
        case .newAddress:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AddNewAddressTableViewCell
            cell.delegate = self
            return cell
        case .listAddress:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AddressTableViewCell
            
            let predicate = NSPredicate(format: "userID == %@", NSNumber(value: userId!))
            let addresses = coreDataHelper.fetchFromCoreData(forEntity: "AddressList", withPredicate: predicate)
            
            if indexPath.row < addresses.count {
                    let address = addresses[indexPath.row]
                    if let addressText = address.value(forKey: "address") as? String {
                        cell.textAddress.text = addressText
                    }
                }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let addressSection = Address(rawValue: indexPath.section) else {
            return
        }
        
        switch addressSection {
        case .newAddress:
            break
            
        case .listAddress:
            let predicate = NSPredicate(format: "userID == %@", NSNumber(value: userId!))
            let addresses = coreDataHelper.fetchFromCoreData(forEntity: "AddressList", withPredicate: predicate)
            
            if indexPath.row < addresses.count {
                let selectedAddress = addresses[indexPath.row]
                
                updateCheckOutAddress(newAddress: selectedAddress.value(forKey: "address") as? String)
            }
        }
    }
    
    func updateCheckOutAddress(newAddress: String?) {
        let checkouts = coreDataHelper.fetchFromCoreData(forEntity: "CheckOut", withPredicate: nil)
        
        if let checkout = checkouts.first {
            checkout.setValue(newAddress, forKey: "address")
            coreDataHelper.saveContext()
            delegate?.didSelectAddress()
        }
    }
    
}
