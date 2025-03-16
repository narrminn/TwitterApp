import Foundation

protocol LoginManagerUseCase {
    func login(email: String, password: String, completion: @escaping((LoginModel?, String?) -> Void))
}

class LoginManager: LoginManagerUseCase {
    var manager = NetworkManager()
    
    func login(email: String, password: String, completion: @escaping((LoginModel?, String?) -> Void)) {
        let path = LoginEndpoint.login.path
        
        let params = [
            "email": email,
            "password": password
        ]
        
        manager.request(path: path, model: LoginModel.self, method: .post, params: params, encodingType: .json, completion: completion)
    }
}

