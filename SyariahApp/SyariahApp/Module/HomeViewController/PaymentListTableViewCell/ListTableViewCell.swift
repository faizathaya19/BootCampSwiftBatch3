import UIKit

class BaseTableCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

// Enum to represent the cell type
enum CellType {
    case payment
    case promotion
}

class ListTableViewCell: BaseTableCell {
    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    var data: [Item] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var didSelectItem: ((Item) -> Void)?
    var cellType: CellType = .payment // Default to payment cell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    func configure(title: String, data: [Item]) {
        titleView.text = title
        self.data = data
    }

    private func configureCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        switch cellType {
        case .payment:
            guard let paymentCell = cell as? PaymentListCollectionViewCell else { return }
            configurePaymentCell(paymentCell, at: indexPath)
        case .promotion:
            guard let promotionCell = cell as? PromotionCollectionViewCell else { return }
            configurePromotionCell(promotionCell, at: indexPath)
        }
    }

    private func getItemSize(for cellType: CellType) -> CGSize {
        switch cellType {
        case .payment:
            return CGSize(width: 80, height: 90)
        case .promotion:
            // Return different size for promotion cells
            // Modify this as per your requirement
            return CGSize(width: 300, height: 150)
        }
    }

    private func configurePaymentCell(_ cell: PaymentListCollectionViewCell, at indexPath: IndexPath) {
        cell.paymentTitleCollectionCell.text = data[indexPath.item].name
        cell.paymentImageCollectionCell.image = UIImage(named: data[indexPath.item].imageName)
    }

    private func configurePromotionCell(_ cell: PromotionCollectionViewCell, at indexPath: IndexPath) {
        cell.promotionImageCollectionCell.image = UIImage(named: data[indexPath.item].imageName)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true

        collectionView.register(UINib(nibName: "PaymentListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "paymentCell")
        collectionView.register(UINib(nibName: "PromotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "promotionCell")

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 6
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.itemSize = getItemSize(for: cellType)
        }
    }
}

extension ListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell

        switch cellType {
        case .payment:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentCell", for: indexPath)
        case .promotion:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "promotionCell", for: indexPath)
        }

        // Update the item size dynamically
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = getItemSize(for: cellType)
        }

        configureCell(cell, at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = data[indexPath.item]
        didSelectItem?(selectedItem)
    }
}
