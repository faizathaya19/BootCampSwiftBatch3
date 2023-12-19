class ProductsService {

    static let shared = ProductsService()

    // Modify the performProduct function to accept a closure
    func performProduct(with productParam: ProductParam, completion: @escaping ([ProductModel]) -> Void) {
        APIManager.shared.makeAPICall(endpoint: .products(productParam)) { (result: Result<ResponseProductModel, Error>) in
            switch result {
            case .success(let responseProduct):
                // Update the product data
                
                let newData = responseProduct.data.data
                // Invoke the closure with the updated data
                completion(newData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
