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
        paymentCollectionView.register(UINib(nibName: "PaymentListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

        // Use a grid layout for the collection view
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PaymentListCollectionViewCell

        cell.paymentTitleCollectionCell.text = data[indexPath.item].name
        cell.paymentImageCollectionCell.image = UIImage(named: data[indexPath.item].imageName)

        return cell
    }
}
