import SkeletonView

extension HomeSoViewController : HomeSoViewModelDelegate{
    func reloadData() {
        homeSoTableView.reloadData()
        homeSoTableView.hideSkeleton()
    }
    
    func didFailFetch() {
        homeSoTableView.showAnimatedGradientSkeleton(usingGradient: Constants.skeletonColor)
        
        let actionYes: [String: () -> Void] = ["Refresh": { [weak self] in
            self?.viewModel.fetchFirst()
        }]
        let actionNo: [String: () -> Void] = ["X": {
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(EXIT_SUCCESS)
            }}]
        
        let arrayActions = [actionYes, actionNo]
        
        showCustomAlertWith(
            title: "Error",
            message: "Failed to fetch data. Do you want to try again?",
            image: #imageLiteral(resourceName: "ic_error"),
            actions: arrayActions
        )
    }
    
    func ifNewUser(){
        showCustomPIN()
    }
}

extension HomeSoViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return HomeSo.allCases.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let homeSoSection = HomeSo(rawValue: indexPath.section)
        
        switch homeSoSection {
        case .headerSo:
            return String(describing: HeaderSoTableViewCell.self)
        case .categorySo:
            return String(describing: CategorySoTableViewCell.self)
        case .headerForYouSo, .headerPopularSo, .headerNewArrivalSo:
            return String(describing: HeaderForTableViewCell.self)
        case .popularSo:
            return String(describing: PopularSoTableViewCell.self)
        case .newArrivalSo, .forYouSo:
            return String(describing: ProductSoTableViewCell.self)
        default:
            return ""
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let homeSoSection = HomeSo(rawValue: section) else {
            return 1
        }
        
        switch homeSoSection {
        case .headerSo, .categorySo:
            return 1
        case .popularSo:
            return (viewModel.selectedCategoryId == Constants.defaultCategoryId) ? 1 : 0
        case .newArrivalSo, .forYouSo:
            return 6
        case .headerPopularSo, .headerNewArrivalSo, .headerForYouSo:
            return 0
        }
    }
}
