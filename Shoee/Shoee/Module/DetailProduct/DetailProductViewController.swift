import UIKit

enum CollectionViewType {
    case detailImage
    case familiarShoes
    // Add more cases if needed for different collection view types
}

class DetailProductViewController: UIViewController {
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var containerViewPrice: UIView!
    @IBOutlet weak var detailImageCollectionView: UICollectionView!
    @IBOutlet weak var containerDetail: UIView!
    @IBOutlet weak var familiarShoesCollectionView: UICollectionView!
    @IBOutlet weak var pagerViewImage: CustomPageControl!
    
    var currentIndex = 0
    var timer: Timer?
    
    let imageDetailPro: [UIImage?] = [
        UIImage(named: "ex_shoes"),
        UIImage(named: "ex_shoes"),
        UIImage(named: "ex_shoes"),
        UIImage(named: "ex_shoes"),
        UIImage(named: "ex_shoes"),
        UIImage(named: "ex_shoes"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(type: .detailImage, collectionView: detailImageCollectionView)
        setupCollectionView(type: .familiarShoes, collectionView: familiarShoesCollectionView)
        startTimer()
        containerViewPrice.layer.cornerRadius = 10
    }
    
    func setupCollectionView(type: CollectionViewType, collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        switch type {
        case .detailImage:
            collectionView.register(UINib(nibName: "DetailProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "detailProductCollectionViewCell")
            pagerViewImage.numberOfPages = imageDetailPro.count
            containerDetail.layer.cornerRadius = 30
            
        case .familiarShoes:
            collectionView.register(UINib(nibName: "FimiliarShoesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "fimiliarShoesCollectionViewCell")
                    
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        let desiredScrollPosition = (currentIndex < imageDetailPro.count - 1) ? currentIndex + 1 : 0
        detailImageCollectionView.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension DetailProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDetailPro.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case detailImageCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailProductCollectionViewCell", for: indexPath) as! DetailProductCollectionViewCell
            cell.image = imageDetailPro[indexPath.item]
            return cell
            
        case familiarShoesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fimiliarShoesCollectionViewCell", for: indexPath) as! FimiliarShoesCollectionViewCell
            cell.image = imageDetailPro[indexPath.item]
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case detailImageCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case familiarShoesCollectionView:
            return CGSize(width: 80, height: 80)
        default:
            return collectionView.frame.size
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == detailImageCollectionView {
            pagerViewImage.scrollViewDidScroll(scrollView)
            currentIndex = Int(scrollView.contentOffset.x / detailImageCollectionView.frame.size.width)
            pagerViewImage.currentPage = currentIndex
        }
        // Handle scrolling for other collection views if needed
    }
    
    // Add more collection view delegate and data source methods if needed
}
