

protocol SignUpViewModelDelegate: AnyObject {
    func didRegisterSuccessfully()
    func didFailRegistration(with error: Error)
    func navigateToLogin()
}

class SignUpViewModel {
    weak var delegate: SignUpViewModelDelegate?
    var popUpLoading: PopUpLoading?

    func performRegistration(with registerParams: RegisterParam) {
  
            self.popUpLoading?.showInFull()
        
        
        APIManager.shared.makeAPICall(endpoint: .register(registerParams)) { (result: Result<ResponseRegisterModel, Error>) in
            
 
                self.popUpLoading?.dismissImmediately()
            
            
            switch result {
            case .success(let responseRegister):
           
                let accessToken = responseRegister.data.accessToken
                let userID = responseRegister.data.user.id
                
                TokenService.shared.storeToken(with: accessToken)
                UserDefaultManager.saveUserID(userID)

                self.delegate?.didRegisterSuccessfully()

            case .failure(let error):
                self.delegate?.didFailRegistration(with: error)
            }
        }
    }
    
    func navigateToLogin() {
        delegate?.navigateToLogin()
    }
}
