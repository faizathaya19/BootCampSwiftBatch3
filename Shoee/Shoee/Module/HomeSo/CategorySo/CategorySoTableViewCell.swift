

import UIKit
// Model Data
struct Categoryy {
    let id: Int
    let name: String
    // tambahkan properti lain sesuai kebutuhan
}

// Table View Cell
class CategorySoTableViewCell: UITableViewCell {
    @IBOutlet weak var categorySoCollectionView: UICollectionView!

    var categories: [Categoryy] = [] {
        didSet {
            categorySoCollectionView.reloadData()
        }
    }
    
    var selectedCategoryIndex: Int? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        categorySoCollectionView.delegate = self
        categorySoCollectionView.dataSource = self

        categorySoCollectionView.register(UINib(nibName: "CategorySoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categorySoCollectionViewCell")

        if let flowLayout = categorySoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            flowLayout.minimumLineSpacing = 12
            flowLayout.minimumInteritemSpacing = 12
        }
    }
}

extension CategorySoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorySoCollectionViewCell", for: indexPath) as! CategorySoCollectionViewCell

        let category = categories[indexPath.item]

        // Ganti logika berdasarkan properti category yang sesuai
        if selectedCategoryIndex == category.id {
            cell.categoryViewContainer.backgroundColor = UIColor(named: "Primary")
            cell.categoryViewContainer.layer.borderWidth = 0
            cell.categoryViewContainer.layer.borderColor = UIColor.clear.cgColor
            cell.categoryLabel.textColor = UIColor(named: "PrimaryText")
            cell.categoryLabel.font = UIFont.boldSystemFont(ofSize: cell.categoryLabel.font.pointSize)
        } else {
            cell.categoryViewContainer.backgroundColor = UIColor.clear
            cell.categoryViewContainer.layer.borderWidth = 1.0
            cell.categoryViewContainer.layer.borderColor = UIColor.gray.cgColor
            cell.categoryLabel.textColor = UIColor(named: "SecondaryText")
            cell.categoryLabel.font = UIFont.systemFont(ofSize: cell.categoryLabel.font.pointSize, weight: .regular)
        }

        cell.categoryLabel.text = category.name

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < categories.count else {
            print("Invalid index selected")
            return
        }

        selectedCategoryIndex = categories[indexPath.item].id
        collectionView.reloadData()

    }
}
