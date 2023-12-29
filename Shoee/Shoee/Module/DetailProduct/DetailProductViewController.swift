import UIKit
import CoreData

enum CollectionViewType {
    case detailImage
    case familiarShoes
    
    var cellTypes: UICollectionViewCell.Type {
        switch self {
        case .detailImage:
            return DetailProductCollectionViewCell.self
        case .familiarShoes:
            return FimiliarShoesCollectionViewCell.self
        }
    }
}

class DetailProductViewController: UIViewController {
    
    @IBOutlet private weak var categoryName: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var containerViewPrice: UIView!
    @IBOutlet private weak var detailImageCollectionView: UICollectionView!
    @IBOutlet private weak var containerDetail: UIView!
    @IBOutlet private weak var favoriteButtonOutlet: UIButton!
    @IBOutlet private weak var familiarShoesCollectionView: UICollectionView!
    @IBOutlet private weak var pagerViewImage: CustomPageControl!
    
    private var isFavorite = false
    private var currentIndex = 0
    private var timer: Timer?
    private var imageDetailPro: [URL] = []
    private var imageFamiliar: [ProductModel] = []
    
    var productID: Int = 0
    var product: ProductModel?
    
    
    init(productID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.productID = productID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollectionView()
        startTimer()
        fetchProductDetails()
        updateFavoriteButtonUI()
        pagerViewImage.numberOfPages = imageDetailPro.count
    }
    
    
    private func configureUI() {
        navigationController?.isNavigationBarHidden = true
        containerViewPrice.makeCornerRadius(10)
    }
    
    private func setupCollectionView() {
        setupCollectionView(type: .detailImage, collectionView: detailImageCollectionView)
        setupCollectionView(type: .familiarShoes, collectionView: familiarShoesCollectionView)
    }
    
    private func setupCollectionView(type: CollectionViewType, collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerCellWithNib(type.cellTypes)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        let desiredScrollPosition = (currentIndex < imageDetailPro.count - 1) ? currentIndex + 1 : 0
        detailImageCollectionView.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func fetchProductDetails() {
        guard let product = product else { return }
        configureProductDetails(product)
        fetchFamiliarProducts()
    }
    
    private func configureProductDetails(_ product: ProductModel) {
        productName.text = product.name
        categoryName.text = product.category?.name
        priceLabel.text = "$\(product.price)"
        descriptionLabel.text = product.description.replacingOccurrences(of: "\r\n", with: "")
        
        if let galleries = product.galleries, galleries.count >= 6 {
            imageDetailPro = Array(galleries[3...5].compactMap { URL(string: $0.url) })
        } else {
            let defaultImageURL = URL(string: Constants.defaultImageURL)!
            imageDetailPro = [defaultImageURL]
        }
    }
    
    private func performProduct(with productParam: ProductParam, completion: @escaping ([ProductModel]) -> Void) {
        APIManager.shared.makeAPICall(endpoint: .products(productParam)) { (result: Result<ResponseProductModel, Error>) in
            switch result {
            case .success(let responseProduct):
                
                let newData = responseProduct.data.data
                
                completion(newData)
            case .failure(_):
                break
            }
        }
    }
    
    private func fetchFamiliarProducts() {
        guard let categoryId = product?.categoriesId else { return }
        
        performProduct(with: ProductParam(categories: categoryId)) { [weak self] newData in
            self?.imageFamiliar = newData
            self?.familiarShoesCollectionView.reloadData()
        }
        
    }
    
    @IBAction private func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnAskProduct(_ sender: Any) {
        let chatScreenViewController = ChatScreenViewController()
        chatScreenViewController.productAskIsHidden = false
        chatScreenViewController.productAsk = product
        chatScreenViewController.hidesBottomBarWhenPushed = true
        chatScreenViewController.setInitialMessage("Apakah Barang Ini Ready?")
        navigationController?.pushViewController(chatScreenViewController, animated: true)
    }
    
    
    @IBAction private func favoriteButton(_ sender: UIButton) {
        guard let product = self.product else {
            return
        }
        
        if isProductIDInCoreData(productID: product.id) {
            deleteProductIDFromCoreData(productID: product.id)
        } else {
            saveProductIDToCoreData(product: product)
        }
        
        updateFavoriteButtonUI()
    }
    
    @IBAction private func btnAddToCart(_ sender: Any) {
        guard let product = self.product else {
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Items>(entityName: "Items")
        fetchRequest.predicate = NSPredicate(format: "productID == %ld", product.id)
        fetchRequest.fetchLimit = 1
        
        do {
            let itemsArray = try managedContext.fetch(fetchRequest)
            if let existingItem = itemsArray.first {
                existingItem.quantity += 1
            } else {
                let itemsEntity = NSEntityDescription.entity(forEntityName: "Items", in: managedContext)!
                let items = Items(entity: itemsEntity, insertInto: managedContext)
                
                items.productID = Int16(product.id)
                items.quantity = 1
                items.name = product.name
                items.price = product.price
                
                if let galleryModel = product.galleries?.dropFirst(3).first {
                    let imageLink = galleryModel.url
                    items.setValue(imageLink, forKeyPath: "image")
                }
            }
            
            let checkoutFetchRequest = NSFetchRequest<CheckOut>(entityName: "CheckOut")
            checkoutFetchRequest.fetchLimit = 1
            
            let checkouts = try managedContext.fetch(checkoutFetchRequest)
            if let checkout = checkouts.first {
                
                checkout.address = "Your Address"
                checkout.shippingPrice = 10
                checkout.status = "Pending"
                checkout.totalPrice += product.price
            } else {
                let checkoutEntity = NSEntityDescription.entity(forEntityName: "CheckOut", in: managedContext)!
                let checkout = CheckOut(entity: checkoutEntity, insertInto: managedContext)
                
                checkout.address = "Your Address"
                checkout.shippingPrice = 10
                checkout.status = "Pending"
                checkout.totalPrice = product.price
            }
            
            try managedContext.save()
            
            let actionYes: [String: () -> Void] = ["View My Cart": { [weak self] in
                let cartViewController = CartViewController()
                self?.navigationController?.pushViewController(cartViewController, animated: true)
            }]
            let actionNo: [String: () -> Void] = ["X": { }]
            
            let arrayActions = [actionYes, actionNo]
            
            showCustomAlertWith(
                title: "Hurray :)",
                message: "Item added successfully",
                image: #imageLiteral(resourceName: "ic_success"),
                actions: arrayActions
            )
        } catch {
            fatalError()
        }
    }
}

extension DetailProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case detailImageCollectionView:
            return imageDetailPro.count
        case familiarShoesCollectionView:
            return imageFamiliar.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case detailImageCollectionView:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DetailProductCollectionViewCell
            
            configureDetailImageCell(cell, at: indexPath)
            return cell
            
        case familiarShoesCollectionView:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FimiliarShoesCollectionViewCell
            
            configureFamiliarShoesCell(cell, at: indexPath)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func configureDetailImageCell(_ cell: DetailProductCollectionViewCell, at indexPath: IndexPath) {
        cell.imageURL = imageDetailPro[indexPath.item]
    }
    
    
    private func configureFamiliarShoesCell(_ cell: FimiliarShoesCollectionViewCell, at indexPath: IndexPath) {
        if let gallery = imageFamiliar[indexPath.item].galleries, gallery.count > 2 {
            cell.imageURL = URL(string: gallery[2].url)
        } else {
            let defaultImageURL = URL(string: Constants.defaultImageURL)!
            cell.imageURL = defaultImageURL
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case familiarShoesCollectionView:
            let selectedProduct = imageFamiliar[indexPath.item]
            
            if let detailViewController = navigationController?.viewControllers.first(where: { $0 is DetailProductViewController }) as? DetailProductViewController {
                detailViewController.product = selectedProduct
                detailViewController.fetchProductDetails()
                detailViewController.hidesBottomBarWhenPushed = true
                navigationController?.popToViewController(detailViewController, animated: false)
            } else {
                let detailViewController = DetailProductViewController(productID: selectedProduct.id)
                detailViewController.product = selectedProduct
                detailViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(detailViewController, animated: false)
            }
        default:
            break
        }
        
        detailImageCollectionView.reloadData()
        updateFavoriteButtonUI()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == detailImageCollectionView {
            pagerViewImage.scrollViewDidScroll(scrollView)
            currentIndex = Int(scrollView.contentOffset.x / detailImageCollectionView.frame.size.width)
            pagerViewImage.currentPage = currentIndex
        }
    }
}

extension DetailProductViewController {
    
    private func isProductIDInCoreData(productID: Int) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteProduct")
        fetchRequest.predicate = NSPredicate(format: "productID == %ld" , productID)
        
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            return false
        }
    }
    
    private func saveProductIDToCoreData(product: ProductModel) {
        
        if let galleryModel = product.galleries?.dropFirst(3).first {
            let imageLink = galleryModel.url
            
            let dataToSave: [String : Any] = [
                "productID": product.id,
                "name": product.name,
                "price": product.price,
                "imageLink": imageLink]
            
            CoreDataHelper.shared.saveDataToCoreData(entityName: "FavoriteProduct", data: dataToSave)
            
            do {
                
                try CoreDataHelper.shared.managedContext.save()
                
                let customToast = CustomToast(message: "Has been added to the Whitelist", backgroundColor: UIColor(named: "Secondary")!)
                customToast.showToast(duration: 0.5)
            } catch {
                fatalError()
            }
        }
        
    }
    
    private func deleteProductIDFromCoreData(productID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteProduct")
        fetchRequest.predicate = NSPredicate(format: "productID == %ld", productID)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
            try managedContext.save()
            let customToast = CustomToast(message: "Has been removed from the Whitelist", backgroundColor: UIColor(named: "Alert")!)
            customToast.showToast(duration: 0.5)
        } catch {
            fatalError()
        }
    }
    
    private func updateFavoriteButtonUI() {
        guard let productID = product?.id else {
            return
        }
        
        if isProductIDInCoreData(productID: productID) {
            animateBackgroundColorChange(for: favoriteButtonOutlet, to: UIColor.systemPink)
            animateCornerRadiusChange(for: favoriteButtonOutlet, to: favoriteButtonOutlet.frame.height / 2.0)
            isFavorite = true
        } else {
            animateBackgroundColorChange(for: favoriteButtonOutlet, to: UIColor.systemGray2)
            animateCornerRadiusChange(for: favoriteButtonOutlet, to: favoriteButtonOutlet.frame.height / 10.0)
            isFavorite = false
        }
    }
    
    private func animateBackgroundColorChange(for view: UIView, to color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            view.backgroundColor = color
        }
    }
    
    private func animateCornerRadiusChange(for view: UIView, to radius: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            view.layer.cornerRadius = radius
            view.layer.masksToBounds = true
        }
    }
}
