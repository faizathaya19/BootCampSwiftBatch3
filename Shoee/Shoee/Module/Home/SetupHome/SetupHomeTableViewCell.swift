import UIKit

protocol SetupHomeCellDelegate: AnyObject {
    func didSelectCategory(_ category: CategoryModel)
}

class SetupHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    var userList: [User] = []
    var categoryList: [CategoryModel] = []
    var selectedCategoryIndex: Int? = nil
    var hasAutoSelectedCategory: Bool = false
    var categoriesFetched: Bool = false

    var homeSetupTable: HomeSetupTable = .header {
        didSet {
            switch homeSetupTable {
            case .categoryList:
                autoSelectCategory()
            default:
                break
            }
            homeCollectionView.reloadData()
        }
    }

    weak var delegate: SetupHomeCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        if !categoriesFetched {
            fetchCategories()
        }
        fetchUsers()
    }

    private func setupCollectionView() {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self

        homeCollectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "headerCell")
        homeCollectionView.register(UINib(nibName: "CategoryListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryListCell")

        if let flowLayout = homeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = (homeSetupTable == .categoryList) ? .vertical : .horizontal
        }

        homeCollectionView.reloadData()
    }
    
    func fetchUsers() {
            // Assuming UserService.shared.getUsers(completion:) fetches user data
            UserService.shared.getUsers { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let users):
                    self.userList = users
                case .failure(let error):
                    print("Error fetching user data: \(error.localizedDescription)")
                }
            }
        }


    func fetchCategories() {
        showAnimatedGradientSkeleton()
        CategoryService.shared.getCategories { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let categories):
                self.categoryList = categories
                DispatchQueue.main.async {
                    if !self.hasAutoSelectedCategory, let index = self.categoryList.firstIndex(where: { $0.id == 6 }) {
                        self.selectedCategoryIndex = self.categoryList[index].id
                        self.delegate?.didSelectCategory(self.categoryList[index])
                        self.hasAutoSelectedCategory = true
                    }
                    self.hideSkeleton()
                    self.categoriesFetched = true
                }
            case .failure(let error):
                print("Error fetching categories: \(error.localizedDescription)")
                self.hideSkeleton()
            }
        }
    }

    private func autoSelectCategory() {
        if let index = categoryList.firstIndex(where: { $0.id == 6 }) {
            selectedCategoryIndex = categoryList[index].id
        }
    }

    private func configureCategoryListCell(_ cell: CategoryListCollectionViewCell, at indexPath: IndexPath) {
        let category = categoryList[indexPath.item]
        cell.categoryTitle.text = category.name

        if selectedCategoryIndex == category.id {
            cell.viewContainer.backgroundColor = UIColor(named: "Primary")
            cell.viewContainer.layer.borderWidth = 0
            cell.viewContainer.layer.borderColor = UIColor.clear.cgColor
            cell.categoryTitle.textColor = UIColor(named: "PrimaryText")
            cell.categoryTitle.font = UIFont.boldSystemFont(ofSize: cell.categoryTitle.font.pointSize)
        } else {
            cell.viewContainer.backgroundColor = UIColor.clear
            cell.viewContainer.layer.borderWidth = 1.0
            cell.viewContainer.layer.borderColor = UIColor.gray.cgColor
            cell.categoryTitle.textColor = UIColor(named: "SecondaryText")
            cell.categoryTitle.font = UIFont.systemFont(ofSize: cell.categoryTitle.font.pointSize, weight: .regular)
        }
    }
}

extension SetupHomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch homeSetupTable {
        case .categoryList:
            return categoryList.count
        case .header:
            return userList.count
        default:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch homeSetupTable {
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCollectionViewCell
            let user = userList[indexPath.item]
            cell.configure(name: String(user.name.prefix(4)), username: "@\(user.username)" , imageURLString: user.profilePhotoURL)
            return cell
        case .categoryList:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryListCell", for: indexPath) as! CategoryListCollectionViewCell
            configureCategoryListCell(cell, at: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch homeSetupTable {
        case .header:
            return CGSize(width: 393, height: 92)
        case .categoryList:
            return CGSize(width: 91, height: 41)
        default:
            return CGSize(width: 100, height: 100)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < categoryList.count else {
            print("Invalid index selected")
            return
        }

        selectedCategoryIndex = categoryList[indexPath.item].id
        collectionView.reloadData()

        delegate?.didSelectCategory(categoryList[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch homeSetupTable {
        case .categoryList:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        default:
            return UIEdgeInsets.zero
        }
    }

}
