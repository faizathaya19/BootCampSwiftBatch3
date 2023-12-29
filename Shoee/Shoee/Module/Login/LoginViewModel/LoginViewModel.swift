protocol LoginViewModelDelegate: AnyObject {
    func didLoginSuccessfully()
    func didFailLogin(with error: Error)
    func navigateToSignUp()
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    var popUpLoading: PopUpLoading?
    
    func performLogin(with loginParams: LoginParam) {
   
            self.popUpLoading?.showInFull()
     
        APIManager.shared.makeAPICall(endpoint: .login(loginParams)) { [weak self] (result: Result<ResponseLoginModel, Error>) in
            
                self?.popUpLoading?.dismissImmediately()
            
            
            switch result {
            case .success(let responseLoginModel):
                
                let accessToken = responseLoginModel.data.accessToken
                let userID = responseLoginModel.data.user.id
                
                TokenService.shared.storeToken(with: accessToken)
                UserDefaultManager.saveUserID(userID)
                
                self?.delegate?.didLoginSuccessfully()
                
            case .failure(let error):
                self?.popUpLoading?.dismissImmediately()
                self?.delegate?.didFailLogin(with: error)
            }
        }
    }
    
    func navigateToSignUp() {
        delegate?.navigateToSignUp()
    }
}
