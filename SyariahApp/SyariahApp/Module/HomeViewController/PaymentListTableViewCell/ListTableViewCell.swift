import UIKit

class BaseTableCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

// Enum to represent the cell type
enum CellType {
    case topCard
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
    var cellType: CellType = .topCard // Default to payment cell

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
        case .topCard:
            guard cell is TopCardCollectionViewCell else { return }
        case .payment:
            guard let paymentCell = cell as? PaymentListCollectionViewCell else { return }
            configurePaymentCell(paymentCell, at: indexPath)
        case .promotion:
            guard let promotionCell = cell as? PromotionCollectionViewCell else { return }
            configurePromotionCell(promotionCell, at: indexPath)
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
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 6
            flowLayout.minimumInteritemSpacing = 10
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        
        collectionView.register(UINib(nibName: "TopCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "topCardCell")
        collectionView.register(UINib(nibName: "PaymentListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "paymentCell")
        collectionView.register(UINib(nibName: "PromotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "promotionCell")
       
    }
}

extension ListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell

        switch cellType {
        case .topCard:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCardCell", for: indexPath)
        case .payment:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentCell", for: indexPath)
        case .promotion:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "promotionCell", for: indexPath)
        }

        configureCell(cell, at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = data[indexPath.item]
        didSelectItem?(selectedItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellType {
        case .topCard:
            return CGSize(width: 340 , height: 180)
        case .payment:
            return CGSize(width: 80, height: 90)
        case .promotion:
            return CGSize(width: 300, height: 170)
        }
    }
}
