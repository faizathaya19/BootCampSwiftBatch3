import Foundation
import UIKit
import CoreData

enum CheckOutSection: Int, CaseIterable {
    case listItem
    case headerPaymentSelect
    case paymentSelect
    case otherItem
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .listItem:
            return ListitemsTableViewCell.self
        case .headerPaymentSelect:
            return HeaderForTableViewCell.self
        case .paymentSelect:
            return PaymentSelectTableViewCell.self
        case .otherItem:
            return OtherItemCheckOutDetailsTableViewCell.self
        }
    }
}

class CheckOutViewModel {
    
    var paymentBca: [BCAResponse] = []
    var checkOut: [CheckOutModel] = []
    var itemList: [Items] = []
    var dataOther: CheckOut!
    var totalPrice: Int16 = 0
    var totalQuantity: Int16 = 0
    
    var paymentSelectionData: PaymentSelectModel?
    
    var updateHandler: (() -> Void)?
    
    init() {
        // Initialize any properties if needed
    }
    
    func fetchData() {
        fetchCheckOutFromCoreData()
        fetchListitemsFromCoreData()
       
    }
    
    func performBCACheckout(with bcaParam: BCAParam, completion: @escaping (Result<BCAResponse, Error>) -> Void) {
        let endpoint = PaymentGateWayEndPoint.vaBCA(bcaParam)
        APIManagerPaymentGateWay.shared.makeAPICall(endpoint: endpoint, completion: completion)
    }
    
    
    func performCheckOut(with checkOut: CheckOutParam, completion: @escaping (Result<ResponseCheckOut, Error>) -> Void) {
        APIManager.shared.makeAPICall(endpoint: .checkout(checkOut), completion: completion)
    }
    
    private func fetchCheckOutFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CheckOut>(entityName: "CheckOut")
        
        do {
            dataOther = try managedContext.fetch(fetchRequest).first
            updateHandler?()
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
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
            
            updateHandler?()
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
    }
    
  
    
    internal func didSelectPayment(_ paymentData: PaymentSelectModel) {
        paymentSelectionData = paymentData
        updateHandler?()
    }
 
}
