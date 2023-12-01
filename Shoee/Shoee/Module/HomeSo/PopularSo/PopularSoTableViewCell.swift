import UIKit

class PopularSoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var popularSoCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        popularSoCollectionView.delegate = self
        popularSoCollectionView.dataSource = self
        
        // Set up collection view flow layout
        if let flowLayout = popularSoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            flowLayout.minimumLineSpacing = 8
            flowLayout.minimumInteritemSpacing = 8
        }
        
        popularSoCollectionView.register(UINib(nibName: "PopularSoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "popularSoCollectionViewCell")
    }
    
}

extension PopularSoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularSoCollectionViewCell", for: indexPath) as! PopularSoCollectionViewCell
        
        return cell
    }
}
