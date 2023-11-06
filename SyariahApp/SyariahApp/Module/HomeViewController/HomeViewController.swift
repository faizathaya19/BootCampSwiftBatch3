import UIKit

enum PaymentType: String {
    case telco = "Telco"
    case pln = "PLN"
    case pdam = "PDAM"
    case sekolah = "Sekolah"
}

protocol Sectionable {
    var title: String { get }
    var data: [Item] { get }
}

enum TableSection: Int, CaseIterable, Sectionable {
    case topCard
    case payments
    case promotions

    var title: String {
        switch self {
            case .topCard:
                        return ""
            case .payments:
                return "List Pembayaran"
            case .promotions:
                return "Promo dan Diskon"
        }
    }

    var data: [Item] {
        switch self {
        case .topCard:
            return [Item(name: "", imageName: "")]
        case .payments:
            return [
                Item(name: PaymentType.telco.rawValue, imageName: "ic_telco"),
                Item(name: PaymentType.pln.rawValue, imageName: "ic_pln"),
                Item(name: PaymentType.pdam.rawValue, imageName: "ic_pdam"),
                Item(name: PaymentType.sekolah.rawValue, imageName: "ic_school")
            ]
        case .promotions:
            return [
                Item(name: "Promo 1", imageName: "bg_banner_4"),
                Item(name: "Promo 2", imageName: "bg_banner_4"),
                Item(name: "Diskon 1", imageName: "bg_banner_4"),
                Item(name: "Diskon 2", imageName: "bg_banner_4")
            ]
        }
    }
}

class HomeViewController: UIViewController {

    @IBOutlet weak var cardViewMyBalance: FormView!
    @IBOutlet weak var homeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

// MARK: - Private Methods
private extension HomeViewController {
    func setupTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }

    func navigateToViewController(for item: Item) {
        guard let paymentType = PaymentType(rawValue: item.name) else { return }
        let viewController: UIViewController

        switch paymentType {
        case .telco: viewController = TelcoViewController()
        case .pln: viewController = PLNViewController()
        case .pdam: viewController = PDAMViewController()
        case .sekolah: viewController = SchoolViewController()
        }

        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell

        guard let section = TableSection(rawValue: indexPath.section) else { return cell }

        cell.cellType = (section == .payments) ? .payment : ((section == .promotions) ? .promotion : .topCard)
        cell.configure(title: section.title, data: section.data)

        cell.didSelectItem = { selectedItem in
            self.navigateToViewController(for: selectedItem)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let section = TableSection(rawValue: indexPath.section) else { return }
        let selectedItem = section.data[indexPath.row]

        navigateToViewController(for: selectedItem)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = TableSection(rawValue: indexPath.section) else { return UITableView.automaticDimension }

        switch section {
        case .topCard: return 230.0
        case .payments: return 170.0
        case .promotions: return 230.0
        }
    }
}
