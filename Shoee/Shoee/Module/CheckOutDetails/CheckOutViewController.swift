import UIKit
import CoreData
import FloatingPanel

class CheckOutViewController: UIViewController, FloatingPanelControllerDelegate {
    
    @IBOutlet weak var checkOutDetailsTableView: UITableView!
    private var viewModel = CheckOutViewModel()
    private var floatingPanelController: FloatingPanelController?
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkOutDetailsTableView.delegate = self
        checkOutDetailsTableView.dataSource = self
        registerCells()
        viewModel.updateHandler = { [weak self] in
            self?.reloadData()
        }
        viewModel.fetchData()
    }
    
    private func registerCells() {
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
            
        } else {
            showCustomPIN(with: viewModel.itemList, dataOther: viewModel.dataOther!, paymentSelectionData: viewModel.paymentSelectionData!)
        }
    }


}

extension CheckOutViewController: UITableViewDelegate, UITableViewDataSource, OtherItemCheckOutDetailsCellDelegate, SelectItemDelegate {
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
        case .headerPaymentSelect:
            return 1
        case .paymentSelect:
            return 1
        case .otherItem:
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

        case .otherItem:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as OtherItemCheckOutDetailsTableViewCell
            cell.delegate = self
            let data = viewModel.dataOther
            cell.configure(address: data?.address ?? "", productQuantity: Int(viewModel.totalQuantity), productPrice: Double(viewModel.totalPrice), totalPrice: Double(viewModel.totalPrice))
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let checkOutSection = CheckOutSection(rawValue: indexPath.section) else {
            return
        }
        
        switch checkOutSection {
        case .paymentSelect:
            showFloatingPanel()
        default:
            break
        }
    }
    
    func showFloatingPanel() {
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
    
    func didSelectPayment(_ paymentData: PaymentSelectModel) {
        viewModel.didSelectPayment(paymentData)
        floatingPanelController?.removePanelFromParent(animated: true)
    }
}

