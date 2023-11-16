import UIKit

class PopularProductTableViewCell: BaseTableCell {
    
    @IBOutlet weak var popularProductCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var popularProductImages: [String] = ["ex_shoes", "ex_shoes", "ex_shoes"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }

    func configure(withTitle title: String?) {
        titleLabel.text = title
        popularProductCollectionView.reloadData()
    }

    private func configureCollectionView() {
        popularProductCollectionView.delegate = self
        popularProductCollectionView.dataSource = self
        popularProductCollectionView.register(UINib(nibName: "PopularProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "popularProductCollectionViewCell")
    }
}

extension PopularProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularProductImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularProductCollectionViewCell", for: indexPath) as! PopularProductCollectionViewCell
        let imageName = popularProductImages[indexPath.item]
        cell.configure(withImageName: imageName)
        return cell
    }
        
}
