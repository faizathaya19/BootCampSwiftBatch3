import UIKit

class BaseTableCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

class PaymentListTableViewCell: BaseTableCell {

    @IBOutlet weak var paymentTitleView: UILabel!
    @IBOutlet weak var paymentCollectionView: UICollectionView!

    var data: [Item] = [] {
        didSet {
            paymentCollectionView.reloadData()
        }
    }

    var didSelectItem: ((Item) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupCollectionView()
    }

    func configure(title: String, data: [Item]) {
        paymentTitleView.text = title
        self.data = data
    }

    private func setupCollectionView() {
        paymentCollectionView.delegate = self
        paymentCollectionView.dataSource = self
        paymentCollectionView.isUserInteractionEnabled = true
        
        paymentCollectionView.register(UINib(nibName: "PaymentListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "paymentCell")
        
        paymentCollectionView.register(UINib(nibName: "PromotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "promotionCell")

        if let flowLayout = paymentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 6
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.itemSize = CGSize(width: 80, height: 90)
        }
    }
}

extension PaymentListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell

        let section = TableSection.allCases[collectionView.tag]

        switch section {
        case .payments:
            let paymentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentCell", for: indexPath) as! PaymentListCollectionViewCell
            configurePaymentCell(paymentCell, at: indexPath)
            cell = paymentCell
        case .promotions:
            let promotionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "promotionCell", for: indexPath) as! PromotionCollectionViewCell
            configurePromotionCell(promotionCell, at: indexPath)
            cell = promotionCell
        }

        return cell
    }

    private func configurePaymentCell(_ cell: PaymentListCollectionViewCell, at indexPath: IndexPath) {
        cell.paymentTitleCollectionCell.text = data[indexPath.item].name
        cell.paymentImageCollectionCell.image = UIImage(named: data[indexPath.item].imageName)
    }

    private func configurePromotionCell(_ cell: PromotionCollectionViewCell, at indexPath: IndexPath) {
        let dataForSection = TableSection.promotions.data
        cell.promotionTitleCollectionCell.text = dataForSection[indexPath.item].name
        cell.promotionImageCollectionCell.image = UIImage(named: dataForSection[indexPath.item].imageName)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = data[indexPath.item]
        didSelectItem?(selectedItem)
    }
}
