import Foundation

class CheckOutViewModel {
    func performBCACheckout(with bcaParam: BCAParam) {
       
        
        // Create the EndPoint with BCAParam
        let endpoint = PaymentGateWayEndPoint.vaBCA(bcaParam)

        // Make the API call
        APIManagerPaymentGateWay.shared.makeAPICall(endpoint: endpoint) { (result: Result<BCAResponse, Error>) in
            switch result {
            case .success(let response):
                // Handle the successful BCA response
                print("BCA Checkout Success: \(response)")
            case .failure(let error):
                // Handle the error
                print("BCA Checkout Error: \(error)")
            }
        }
    }
}
