import UIKit
import CoreData
import FloatingPanel

class CheckOutViewController: UIViewController, FloatingPanelControllerDelegate {
    
    @IBOutlet weak var checkOutDetailsTableView: UITableView!
    private var viewModel = CheckOutViewModel()
    private var floatingPanelController: FloatingPanelController?
    lazy var popUpLoading = PopUpLoading(on: view)
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        registerCells()
        viewModel.updateHandler = { [weak self] in
            self?.reloadData()
        }
        viewModel.fetchData()
        viewModel.delegate = self
        viewModel.popUpLoading = popUpLoading
    }
    
    private func registerCells() {
        checkOutDetailsTableView.delegate = self
        checkOutDetailsTableView.dataSource = self
        
        CheckOutSection.allCases.forEach { cell in
            checkOutDetailsTableView.registerCellWithNib(cell.cellTypes)
        }
    }
    
    func reloadData() {
        checkOutDetailsTableView.reloadData()
    }
    
    func checkOutButtonTapped(inCell cell: OtherItemCheckOutDetailsTableViewCell) {
        if viewModel.paymentSelectionData == nil {
            
            showCustomAlertWith(
                detailResponseOkAction: nil,
                title: "Error",
                message: "Please, Select Your Payment Method",
                image: #imageLiteral(resourceName: "ic_error"),
                actions: nil
            )
            
        } else if ((viewModel.dataOther?.address) == "Your Address") {
            
            showCustomAlertWith(
                detailResponseOkAction: nil,
                title: "Error",
                message: "Please, Select Or Input Your Address",
                image: #imageLiteral(resourceName: "ic_error"),
                actions: nil
            )
            
        } else {
                showCustomPIN {
                    self.viewModel.checkOutALL()
                }
        }
    }
}

extension CheckOutViewController: UITableViewDelegate, UITableViewDataSource, OtherItemCheckOutDetailsCellDelegate, SelectItemDelegate , CheckOutModelDelegate, SelectAddressDelegate{
    func didSelectAddress() {
        viewModel.didSelectAddress()
        floatingPanelController?.removePanelFromParent(animated: true)
    }
    
    func successCheckOut() {
        DispatchQueue.main.async {
            let vC = PaymentProcessViewController(paymentID: self.viewModel.orderId!)
            vC.paymentBCA = self.viewModel.paymentBca
            self.navigationController?.pushViewController(vC, animated: true)
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CheckOutSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let checkOutSection = CheckOutSection(rawValue: section) else {
            return 0
        }
        
        switch checkOutSection {
        case .listItem:
            return viewModel.itemList.count
        case .headerPaymentSelect, .paymentSelect, .otherItem, .addressDetail:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let checkOutSection = CheckOutSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch checkOutSection {
        case .listItem:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ListitemsTableViewCell
            let item = viewModel.itemList[indexPath.row]
            let imageURL = item.image ?? Constants.defaultImageURL
            cell.configure(withQuantity: Int(item.quantity), price: item.price, productName: item.name ?? "", imageURL: imageURL)
            tableView.contentInset.top = 20
            return cell
        case .headerPaymentSelect:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderForTableViewCell
            cell.configure(title: "Select Payment")
            return cell
        case .paymentSelect:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PaymentSelectTableViewCell

            if let paymentSelectionData = viewModel.paymentSelectionData {
                cell.configure(data: paymentSelectionData.image, name: paymentSelectionData.name)
            } else {
                cell.configure(data: "", name: "Select Your Payment", hideimage: true)
            }
            return cell
            
        case .addressDetail:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AddressDetailTableViewCell
            let data = viewModel.dataOther
            cell.configure(address: data?.address ?? "")
            return cell
        case .otherItem:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as OtherItemCheckOutDetailsTableViewCell
            cell.delegate = self
            cell.configure(productQuantity: Int(viewModel.totalQuantity), productPrice: "$ \(Double(viewModel.totalPrice))", totalPrice: "$ \(Double(viewModel.totalPrice))")
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let checkOutSection = CheckOutSection(rawValue: indexPath.section) else {
            return
        }
        
        switch checkOutSection {
        case .paymentSelect:
            showAddPayment()
        case .addressDetail:
            showEditAddress()
        default:
            break
        }
    }
    
    func showAddPayment() {
        if floatingPanelController == nil {
            floatingPanelController = FloatingPanelController()
            floatingPanelController?.delegate = self
        }
        
        if let paymentSelectViewController = floatingPanelController?.contentViewController as? SelectItemViewController {
            paymentSelectViewController.delegate = self
        } else {
            let paymentSelectViewController = SelectItemViewController()
            paymentSelectViewController.delegate = self
            floatingPanelController?.set(contentViewController: paymentSelectViewController)
        }
        
        floatingPanelController?.isRemovalInteractionEnabled = true
        floatingPanelController?.backdropView.alpha = 0.3
        
        floatingPanelController?.addPanel(toParent: self)
    }
    
    func showEditAddress() {
        if floatingPanelController == nil {
            floatingPanelController = FloatingPanelController()
            floatingPanelController?.delegate = self
        }
        
        if let addressViewController = floatingPanelController?.contentViewController as? AddressViewController {
            addressViewController.delegate = self
        } else {
            let addressViewController = AddressViewController()
            
            addressViewController.delegate = self
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillHide(_:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillShow(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
            
            floatingPanelController?.set(contentViewController: addressViewController)
        }
        
        floatingPanelController?.isRemovalInteractionEnabled = true
        floatingPanelController?.backdropView.alpha = 0.3
        
        floatingPanelController?.addPanel(toParent: self)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        floatingPanelController?.move(to: .half, animated: true)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        floatingPanelController?.move(to: .full, animated: true)
    }

    
    func didSelectPayment(_ paymentData: PaymentSelectModel) {
        viewModel.didSelectPayment(paymentData)
        floatingPanelController?.removePanelFromParent(animated: true)
    }
}

