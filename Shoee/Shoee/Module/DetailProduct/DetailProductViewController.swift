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
    
    var productID: Int = 0
    var product: ProductModel?
    
    // Add any other properties and methods as needed
    
    init(productID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.productID = productID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var containerViewPrice: UIView!
    @IBOutlet weak var detailImageCollectionView: UICollectionView!
    @IBOutlet weak var containerDetail: UIView!
    @IBOutlet weak var familiarShoesCollectionView: UICollectionView!
    @IBOutlet weak var pagerViewImage: CustomPageControl!
    
    var currentIndex = 0
    var timer: Timer?
    
    var imageDetailPro: [URL] = [] // Updated
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(type: .detailImage, collectionView: detailImageCollectionView)
        setupCollectionView(type: .familiarShoes, collectionView: familiarShoesCollectionView)
        startTimer()
        containerViewPrice.layer.cornerRadius = 10
        // Set the category name
        categoryName.text = product?.category.name
        
        // Assuming product is not nil
        if let galleries = product?.galleries, galleries.count >= 6 {
                   imageDetailPro = Array(galleries[3...5].compactMap { URL(string: $0.url) })
               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupCollectionView(type: CollectionViewType, collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
        
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
        print(desiredScrollPosition)
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
            pagerViewImage.numberOfPages = imageDetailPro.count
            cell.imageURL = imageDetailPro[indexPath.item]
            return cell
            
        case familiarShoesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fimiliarShoesCollectionViewCell", for: indexPath) as! FimiliarShoesCollectionViewCell
            cell.imageURL = imageDetailPro[indexPath.item]
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
    }
}
