import Foundation
import UIKit
import CoreData

enum CheckOutSection: Int, CaseIterable {
    case listItem
    case addressDetail
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
        case .addressDetail:
            return AddressDetailTableViewCell.self
        case .otherItem:
            return OtherItemCheckOutDetailsTableViewCell.self
        }
    }
}

protocol CheckOutModelDelegate: AnyObject {
    func successCheckOut()
}

class CheckOutViewModel {
    
    weak var delegate: CheckOutModelDelegate?
    
    var userData: UserModel?
    var paymentBca: BCAResponse?
    var checkOut: [CheckOutModel] = []
    var itemList: [Items] = []
    var dataOther: CheckOut!
    var totalPrice: Int16 = 0
    var totalQuantity: Int16 = 0
    var orderId: String?
    var popUpLoading: PopUpLoading?
    var paymentSelectionData: PaymentSelectModel?
    
    var updateHandler: (() -> Void)?
    
    func fetchData() {
        fetchCheckOutFromCoreData()
        fetchListitemsFromCoreData()
        fetchUsers()
    }
    
    func performBCACheckout(with bcaParam: BCAParam, completion: @escaping (Result<BCAResponse, Error>) -> Void) {
        let endpoint = PaymentGateWayEndPoint.va(bcaParam)
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
            fatalError()
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
            fatalError()
        }
    }
    
    private func fetchUsers() {
        APIManager.shared.makeAPICall(endpoint: .user) { [weak self] (result: Result<ResponseUserModel, Error>) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.userData = response.data
                case .failure(_):
                    break
                }
            }
        }
    }
    
    internal func didSelectPayment(_ paymentData: PaymentSelectModel) {
        paymentSelectionData = paymentData
        updateHandler?()
    }
    
    internal func didSelectAddress() {
        fetchCheckOutFromCoreData()
        updateHandler?()
    }
    
    func generateOrderID() {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyyMMddHHmmss"
           let currentDateTime = Date()
           orderId = "order-\(dateFormatter.string(from: currentDateTime))"
       }
    
    func checkOutALL() {
        generateOrderID()

        let dispatchGroup = DispatchGroup()
        self.popUpLoading?.showInFull()
        
        dispatchGroup.enter()
        checkOutData {
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        bcaCheckout {
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            CoreDataHelper.shared.deleteAllData(forEntity: "Items")
            CoreDataHelper.shared.deleteAllData(forEntity: "CheckOut")
            self.popUpLoading?.dismissAfter1()
            self.delegate?.successCheckOut()
        }
    }

    func checkOutData(completion: @escaping () -> Void) {
        guard let address = dataOther?.address else {
            completion()
            return
        }

        totalPrice = Int16(itemList.reduce(0) { $0 + Double($1.price) * Double($1.quantity) })

        let itemParams = itemList.map { item in
            return itemParam(id: "\(item.productID)", quantity: Int(item.quantity))
        }

        let checkOutParam = CheckOutParam(
            address: address,
            items: itemParams,
            status: "PENDING",
            totalPrice: Int(totalPrice),
            shippingPrice: 13000,
            payment: paymentSelectionData?.name ?? "",
            paymentId: orderId!
        )

        performCheckOut(with: checkOutParam) { result in
            switch result {
            case .success(_):
                completion()
            case .failure(_):
                completion()
            }
        }
    }

    func bcaCheckout(completion: @escaping () -> Void) {
        totalPrice = Int16(itemList.reduce(0) { $0 + Double($1.price) * Double($1.quantity) })

        let transaction = transactionDetails(orderId: orderId!, grossAmount: Int(totalPrice))
        let bank = bankTransfer(bank: paymentSelectionData?.title ?? "", vaNumber: userData?.phone ?? "")

        let itemDetailsArray = itemList.map { item in
            return itemDetails(
                id: "\(item.productID)",
                price: Int(item.price),
                quantity: Int(item.quantity),
                name: item.name ?? ""
            )
        }

        let customer = customerDetails(email: userData!.email, firstName: userData!.name.components(separatedBy: " ").first ?? "", lastName: userData!.name.components(separatedBy: " ").last ?? "", phone: userData!.phone ?? "")

        let bcaParam = BCAParam(
            transactionDetails: transaction,
            bankTransfer: bank,
            customerDetails: customer,
            itemDetails: itemDetailsArray
        )

        performBCACheckout(with: bcaParam) { result in
            switch result {
            case .success(let response):
                self.paymentBca = response
                completion()
            case .failure(_):
                completion()
            }
        }
    }

 
}
