import Foundation

class CheckOutViewModel {
    
    var paymentBca : [BCAResponse] = []
    
    func performBCACheckout(with bcaParam: BCAParam) {
        let endpoint = PaymentGateWayEndPoint.vaBCA(bcaParam)
        APIManagerPaymentGateWay.shared.makeAPICall(endpoint: endpoint) { (result: Result<BCAResponse, Error>) in
            switch result {
            case .success(let response):
                self.paymentBca = [response]
                print("BCA Checkout Success: \(response)")
            case .failure(let error):
                // Handle the error
                print("BCA Checkout Error: \(error)")
            }
        }
    }
}
