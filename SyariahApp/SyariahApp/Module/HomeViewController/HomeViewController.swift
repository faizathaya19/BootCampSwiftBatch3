import UIKit

// Define the payment types
enum PaymentType: String {
    case telco = "Telco"
    case pln = "PLN"
    case pdam = "PDAM"
    case sekolah = "Sekolah"
}

// Define protocol to get data and title
protocol Sectionable {
    var title: String { get }
    var data: [Item] { get }
}

// Enum to define sections
enum TableSection: Int, CaseIterable, Sectionable {
    case payments
    case promotions

    var title: String {
        switch self {
        case .payments:
            return "List Pembayaran"
        case .promotions:
            return "Promo dan Diskon"
        }
    }

    var data: [Item] {
        switch self {
        case .payments:
            return [
                Item(name: PaymentType.telco.rawValue, imageName: "ic_telco"),
                Item(name: PaymentType.pln.rawValue, imageName: "ic_pln"),
                Item(name: PaymentType.pdam.rawValue, imageName: "ic_pdam"),
                Item(name: PaymentType.sekolah.rawValue, imageName: "ic_school")
            ]
        case .promotions:
            return [
                Item(name: "Promo 1", imageName: "bg_login"),
                Item(name: "Promo 2", imageName: "bg_login"),
                Item(name: "Diskon 1", imageName: "bg_login"),
                Item(name: "Diskon 2", imageName: "bg_login")
            ]
        }
    }
}

class HomeViewController: UIViewController {

    @IBOutlet weak var cardViewMyBalance: FormView!
    @IBOutlet weak var homeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell

        let section = TableSection(rawValue: indexPath.section)

        if let section = section {
            cell.cellType = (section == .payments) ? .payment : .promotion
            cell.configure(title: section.title, data: section.data)

            // Set the didSelectItem closure
            cell.didSelectItem = { selectedItem in
                self.navigateToViewController(for: selectedItem)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = TableSection(rawValue: indexPath.section)
        let selectedItem = section?.data[indexPath.row]

        if let selectedItem = selectedItem {
            navigateToViewController(for: selectedItem)
        }
    }

    // MARK: - Navigation
    func navigateToViewController(for item: Item) {
        guard let paymentType = PaymentType(rawValue: item.name) else { return }
        let viewController: UIViewController

        switch paymentType {
        case .telco:
            viewController = TelcoViewController()
        case .pln:
            viewController = PLNViewController()
        case .pdam:
            viewController = PDAMViewController()
        case .sekolah:
            viewController = SchoolViewController()
        }

        navigationController?.pushViewController(viewController, animated: true)
    }
}
