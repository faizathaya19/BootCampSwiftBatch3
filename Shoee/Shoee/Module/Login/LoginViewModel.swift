import UIKit


protocol LoginViewModelDelegate: AnyObject {
    func didLoginSuccessfully()
    func didFailLogin(with error: Error)
    func navigateToSignUp()
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    var popUpLoading: PopUpLoading?
    
    func performLogin(with loginParams: LoginParam) {
        DispatchQueue.main.async {
            self.popUpLoading?.showInFull()
        }
        
        
        APIManager.shared.makeAPICall(endpoint: .login(loginParams)) { [weak self] (result: Result<ResponseLoginModel, Error>) in
            
            DispatchQueue.main.async {
                self?.popUpLoading?.dismissImmediately()
            }
            
            switch result {
            case .success(let responseLoginModel):
                guard let responseLoginModel = responseLoginModel as? ResponseLoginModel else {
                    print("Error: Invalid response structure")
                    return
                }
                
                let accessToken = responseLoginModel.data.accessToken
                TokenService.shared.saveToken(accessToken)
                
                self?.delegate?.didLoginSuccessfully()
                
            case .failure(let error):
                self?.delegate?.didFailLogin(with: error)
            }
        }
    }
    
    func navigateToSignUp() {
        delegate?.navigateToSignUp()
    }
}
