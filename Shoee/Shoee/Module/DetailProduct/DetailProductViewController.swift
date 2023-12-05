import UIKit
import CoreData

enum CollectionViewType {
    case detailImage
    case familiarShoes
    // Add more cases if needed for different collection view types
}

class DetailProductViewController: UIViewController {
    
    // MARK: - Outlets
    
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
    
    // MARK: - Properties
    
    private var isFavorite = false
    private var currentIndex = 0
    private var timer: Timer?
    private var imageDetailPro: [URL] = []
    private var imageFamiliar: [ProductModel] = []
    
    var productID: Int = 0
    var product: ProductModel?
    
    // MARK: - Initialization
    
    init(productID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.productID = productID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollectionView()
        startTimer()
        fetchProductDetails()
        updateFavoriteButtonUI()
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        navigationController?.isNavigationBarHidden = true
        containerViewPrice.layer.cornerRadius = 10
    }
    
    // MARK: - Collection View Setup
    
    private func setupCollectionView() {
        setupCollectionView(type: .detailImage, collectionView: detailImageCollectionView)
        setupCollectionView(type: .familiarShoes, collectionView: familiarShoesCollectionView)
    }
    
    private func setupCollectionView(type: CollectionViewType, collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        switch type {
        case .detailImage:
            collectionView.register(UINib(nibName: "DetailProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "detailProductCollectionViewCell")
        case .familiarShoes:
            collectionView.register(UINib(nibName: "FimiliarShoesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "fimiliarShoesCollectionViewCell")
        }
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        let desiredScrollPosition = (currentIndex < imageDetailPro.count - 1) ? currentIndex + 1 : 0
        print(desiredScrollPosition)
        detailImageCollectionView.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - Fetch Product Details
    
    private func fetchProductDetails() {
        guard let product = product else { return }
        configureProductDetails(product)
        fetchFamiliarProducts()
    }
    
    private func configureProductDetails(_ product: ProductModel) {
        productName.text = product.name
        categoryName.text = product.category.name
        priceLabel.text = "$\(product.price)"
        descriptionLabel.text = product.description.replacingOccurrences(of: "\r\n", with: "")
        
        if let galleries = product.galleries, galleries.count >= 6 {
            imageDetailPro = Array(galleries[3...5].compactMap { URL(string: $0.url) })
        } else {
            let defaultImageURL = URL(string: "https://static.vecteezy.com/system/resources/thumbnails/007/872/974/small/file-not-found-illustration-with-confused-people-holding-big-magnifier-search-no-result-data-not-found-concept-can-be-used-for-website-landing-page-animation-etc-vector.jpg")!
            imageDetailPro = [defaultImageURL]
        }
    }
    
    
    // MARK: - Fetch Familiar Products
    
    private func fetchFamiliarProducts() {
        guard let categoryId = product?.categoriesId else { return }
        
        ProductsService.shared.getProducts(categories: categoryId) { [weak self] result in
            switch result {
            case .success(let products):
                self?.imageFamiliar = products
                self?.familiarShoesCollectionView.reloadData()
            case .failure(let error):
                print("Error fetching familiar shoes: \(error)")
            }
            
            // Move the updateFavoriteButtonUI() call here, after the fetch operation completes
            self?.updateFavoriteButtonUI()
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction private func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction private func favoriteButton(_ sender: Any) {
        guard let favoriteButton = sender as? UIButton else { return }
        
        guard let productID = product?.id else {
            // Handle the case where product is nil or doesn't have a valid ID
            return
        }
        
        if isProductIDInCoreData(productID: productID) {
            // ProductID exists in CoreData, delete it
            deleteProductIDFromCoreData(productID: productID)
        } else {
            // ProductID doesn't exist in CoreData, save it
            saveProductIDToCoreData(product: product!)
        }
        
        // Pemanggilan updateFavoriteButtonUI() ditempatkan di sini
        updateFavoriteButtonUI()
    }
    
    @IBAction private func btnAddToCart(_ sender: Any) {
        guard let product = self.product else {
            // Pastikan ada produk untuk ditambahkan ke keranjang
            return
        }

        // Akses managedObjectContext Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Buat entity 'Items' baru atau perbarui jika sudah ada
        let fetchRequest = NSFetchRequest<Items>(entityName: "Items")
        fetchRequest.predicate = NSPredicate(format: "productID == %ld", product.id)
        fetchRequest.fetchLimit = 1

        do {
            let itemsArray = try managedContext.fetch(fetchRequest)
            if let existingItem = itemsArray.first {
                // Produk sudah ada, tingkatkan quantity
                existingItem.quantity += 1
            } else {
                // Produk belum ada, buat entity 'Items' baru
                let itemsEntity = NSEntityDescription.entity(forEntityName: "Items", in: managedContext)!
                let items = Items(entity: itemsEntity, insertInto: managedContext)

                items.productID = Int16(product.id)
                items.quantity = 1 // Default quantity is 1
                items.name = product.name
                items.price = product.price
                if let galleryModel = product.galleries?.dropFirst(3).first {
                    let imageLink = galleryModel.url
                    items.setValue(imageLink, forKeyPath: "image")
                }
            }

            // Ambil atau buat entity 'CheckOut' (jika diperlukan)
            let checkoutFetchRequest = NSFetchRequest<CheckOut>(entityName: "CheckOut")
            checkoutFetchRequest.fetchLimit = 1

            let checkouts = try managedContext.fetch(checkoutFetchRequest)
            if let checkout = checkouts.first {
                // Perbarui atribut lain di 'CheckOut' jika diperlukan
                checkout.address = "Alamat Anda" 
                checkout.shippingPrice = 10
                checkout.status = "Pending"
                checkout.totalPrice += product.price
            } else {
                // Buat entity 'CheckOut' baru jika tidak ada
                let checkoutEntity = NSEntityDescription.entity(forEntityName: "CheckOut", in: managedContext)!
                let checkout = CheckOut(entity: checkoutEntity, insertInto: managedContext)

                // Atur atribut untuk entity 'CheckOut'
                checkout.address = "Alamat Anda" // Atur alamat sesuai kebutuhan
                checkout.shippingPrice = 10 // Atur biaya pengiriman sesuai kebutuhan
                checkout.status = "Pending" // Atur status sesuai kebutuhan
                checkout.totalPrice = product.price
            }

            // Simpan perubahan ke Core Data
            try managedContext.save()
            let actionYes: [String: () -> Void] = ["View My Cart": { [weak self] in
                let cartViewController = CartViewController()
                self?.navigationController?.pushViewController(cartViewController, animated: true)
            }]
            let actionNo: [String: () -> Void] = ["X": { print("tapped NO") }]
            
            let arrayActions = [actionYes, actionNo]
            
            showCustomAlertWith(
                title: "Hurray :)",
                message: "Item added successfully",
                image: #imageLiteral(resourceName: "ic_success"),
                actions: arrayActions
            )
        } catch {
            print("Error saving to Core Data: \(error)")
        }
    }

    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailProductCollectionViewCell", for: indexPath) as! DetailProductCollectionViewCell
            configureDetailImageCell(cell, at: indexPath)
            return cell
        case familiarShoesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fimiliarShoesCollectionViewCell", for: indexPath) as! FimiliarShoesCollectionViewCell
            configureFamiliarShoesCell(cell, at: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    private func configureDetailImageCell(_ cell: DetailProductCollectionViewCell, at indexPath: IndexPath) {
        pagerViewImage.numberOfPages = imageDetailPro.count
        print("Image URL:", imageDetailPro[indexPath.item])
        cell.imageURL = imageDetailPro[indexPath.item]
    }
    
    
    private func configureFamiliarShoesCell(_ cell: FimiliarShoesCollectionViewCell, at indexPath: IndexPath) {
        if let gallery = imageFamiliar[indexPath.item].galleries, gallery.count > 2 {
            cell.imageURL = URL(string: gallery[2].url)
        } else {
            let defaultImageURL = URL(string: "https://static.vecteezy.com/system/resources/thumbnails/007/872/974/small/file-not-found-illustration-with-confused-people-holding-big-magnifier-search-no-result-data-not-found-concept-can-be-used-for-website-landing-page-animation-etc-vector.jpg")!
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
            
            // Check if the detailViewController is already in the navigation stack
            if let detailViewController = navigationController?.viewControllers.first(where: { $0 is DetailProductViewController }) as? DetailProductViewController {
                // Update the existing instance with the new product
                detailViewController.product = selectedProduct
                detailViewController.fetchProductDetails() // Refresh the data
                detailViewController.hidesBottomBarWhenPushed = true
                navigationController?.popToViewController(detailViewController, animated: false)
            } else {
                // If not in the stack, create a new instance and push it
                let detailViewController = DetailProductViewController(productID: selectedProduct.id)
                detailViewController.product = selectedProduct
                detailViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(detailViewController, animated: false)
            }
        default:
            break
        }
        
        
        
        detailImageCollectionView.reloadData()
        // Pemanggilan updateFavoriteButtonUI() ditempatkan di sini
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

// MARK: - Core Data Operations

extension DetailProductViewController {
    
    private func isProductIDInCoreData(productID: Int) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteProduct")
        fetchRequest.predicate = NSPredicate(format: "productID == %ld", productID)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error checking if productID exists in CoreData: \(error)")
            return false
        }
    }
    
    private func saveProductIDToCoreData(product: ProductModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteProduct", in: managedContext)!
        
        let favoriteProduct = NSManagedObject(entity: entity, insertInto: managedContext)
        favoriteProduct.setValue(product.id, forKeyPath: "productID")
        favoriteProduct.setValue(product.name, forKeyPath: "name")
        favoriteProduct.setValue(product.price, forKeyPath: "price")
        
        if let galleryModel = product.galleries?.dropFirst(3).first {
            let imageLink = galleryModel.url
            favoriteProduct.setValue(imageLink, forKeyPath: "imageLink")
            
        }
        
        
        do {
            try managedContext.save()
            showCustomSlideMess(message: "Has been added to the Whitelist", color: UIColor(named: "Secondary")!)
        } catch {
            print("Error saving product to CoreData: \(error)")
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
            showCustomSlideMess(message: "Has been removed from the Whitelist", color: UIColor(named: "Alert")!)
        } catch {
            print("Error deleting productID from CoreData: \(error)")
        }
    }
    
    private func updateFavoriteButtonUI() {
        guard let productID = product?.id else {
            // Handle the case where product is nil or doesn't have a valid ID
            return
        }
        
        if isProductIDInCoreData(productID: productID) {
            // ProductID exists in CoreData, set button to active state
            animateBackgroundColorChange(for: favoriteButtonOutlet, to: UIColor.systemPink)
            animateCornerRadiusChange(for: favoriteButtonOutlet, to: favoriteButtonOutlet.frame.height / 2.0)
            isFavorite = true
        } else {
            // ProductID doesn't exist in CoreData, set button to inactive state
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
