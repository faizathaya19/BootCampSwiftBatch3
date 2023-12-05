import UIKit

class PopularSoTableViewCell: UITableViewCell {

    @IBOutlet weak var PopularSoCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        PopularSoCollectionView.delegate = self
        PopularSoCollectionView.dataSource = self
        PopularSoCollectionView.register(UINib(nibName: "PopularSoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "popularSoCollectionViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension PopularSoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularSoCollectionViewCell", for: indexPath) as! PopularSoCollectionViewCell
        return cell
    }
}
