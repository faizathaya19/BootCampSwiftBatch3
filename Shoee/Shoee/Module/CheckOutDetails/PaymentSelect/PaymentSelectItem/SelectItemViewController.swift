import UIKit

protocol SelectItemDelegate: AnyObject {
    func didSelectPayment(_ paymentData: PaymentSelectModel)
}

enum PaymentSection: Int, CaseIterable {
    case headerPaymentSelect
    case paymentSelect
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .headerPaymentSelect:
            return HeaderForTableViewCell.self
        case .paymentSelect:
            return PaymentSelectItemTableViewCell.self
        }
    }
    
    var sectionIdentifier: Int {
        return self.rawValue
    }
}

class SelectItemViewController: UIViewController {

    @IBOutlet weak var SelectItemTableView: UITableView!

    var paymentSelectData: [PaymentSelectModel] = [
        PaymentSelectModel(id: 1, image: "ic_bca", name: "BCA Virtual Account", title: "bca"),
        PaymentSelectModel(id: 2, image: "ic_permata", name: "PERMATA Virtual Account", title: "permata"),
        PaymentSelectModel(id: 2, image: "ic_bni", name: "BNI Virtual Account", title: "bni")
    ]

    weak var delegate: SelectItemDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        SelectItemTableView.delegate = self
        SelectItemTableView.dataSource = self
        registerCells()
    }

    private func registerCells() {
        PaymentSection.allCases.forEach { cell in
            SelectItemTableView.registerCellWithNib(cell.cellTypes)
        }
    }
}

extension SelectItemViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return PaymentSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let paymentSection = PaymentSection(rawValue: section) else {
            return 0
        }

        switch paymentSection {
        case .headerPaymentSelect:
            return 1
        case .paymentSelect:
            return paymentSelectData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let paymentSection = PaymentSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch paymentSection {
        case .headerPaymentSelect:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderForTableViewCell
            cell.configure(title: "Select Payment")
            return cell
        case .paymentSelect:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PaymentSelectItemTableViewCell
            let paymentSelectItem = paymentSelectData[indexPath.row]
            cell.configure(data: paymentSelectItem.image, name: paymentSelectItem.name)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let paymentSection = PaymentSection(rawValue: indexPath.section),
              paymentSection == .paymentSelect else {
            return
        }

        let paymentSelectItem = paymentSelectData[indexPath.row]
        delegate?.didSelectPayment(paymentSelectItem)
    }
}
