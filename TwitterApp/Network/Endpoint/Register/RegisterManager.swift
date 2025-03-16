import Foundation

protocol RegisterManagerUseCase {
    func register(username: String, name: String, email: String, password: String, completion: @escaping((RegisterModel?, String?) -> Void))
    func registerApprove(code: String, userId: Int, completion: @escaping((RegisterApproveModel?, String?) -> Void))
}

class RegisterManager: RegisterManagerUseCase {
    var manager = NetworkManager()
    
    func register(username: String, name: String, email: String, password: String, completion: @escaping((RegisterModel?, String?) -> Void)) {
        let path = RegisterEndpoint.register.path
        
        let params = [
            "username": username,
            "name": name,
            "email": email,
            "password": password
        ]
        
        manager.request(path: path, model: RegisterModel.self, method: .post, params: params, encodingType: .json, completion: completion)
    }
    
    func registerApprove(code: String, userId: Int, completion: @escaping((RegisterApproveModel?, String?) -> Void)) {
        let path = RegisterEndpoint.registerApprove(userId: userId).path
        
        let params = [
            "code": code
        ]
        
        manager.request(path: path, model: RegisterApproveModel.self, method: .post, params: params, encodingType: .json, completion: completion)
    }
}

