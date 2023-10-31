import UIKit

// Define protocol to get data and title
protocol Sectionable {
    var title: String { get }
    var data: [Item] { get }
}

// Enum to define sections
enum TableSection: CaseIterable, Sectionable {
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
                Item(name: "Telco", imageName: "ic_telco"),
                Item(name: "PLN", imageName: "ic_pln"),
                Item(name: "PDAM", imageName: "ic_pdam"),
                Item(name: "Sekolah", imageName: "ic_school")
            ]
        case .promotions:
            return [
                Item(name: "Promo 1", imageName: "1"),
                Item(name: "Promo 2", imageName: "2"),
                Item(name: "Diskon 1", imageName: "3"),
                Item(name: "Diskon 2", imageName: "4")
            ]
        }
    }
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cardViewMyBalance: FormView!
    @IBOutlet weak var homeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "PaymentListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentListTableViewCell

        // Configure PaymentListTableViewCell for payments section
        if TableSection.allCases[indexPath.section] == .payments {
            cell.configure(title: TableSection.payments.title, data: TableSection.payments.data)
        }

        return cell
    }
}
