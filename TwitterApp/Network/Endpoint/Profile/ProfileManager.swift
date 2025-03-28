import Foundation

protocol ProfileManagerUseCase {
    func myProfile(completion: @escaping((MyProfileModel?, String?) -> Void))
}

class ProfileManager: ProfileManagerUseCase {
  
    var manager = NetworkManager()
    
    func myProfile(completion: @escaping ((MyProfileModel?, String?) -> Void)) {
        let path = ProfileEndpoint.myProfile.path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: MyProfileModel.self, method: .get, params: nil, header: headers, completion: completion)
    }
}

