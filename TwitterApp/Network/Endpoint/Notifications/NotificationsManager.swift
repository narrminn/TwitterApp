import Foundation

protocol NotificationsManagerUseCase {
    
    //async await
    func notifications(page: Int) async throws -> NotificationsModel
}

class NotificationsManager: NotificationsManagerUseCase {
   
    var manager = NetworkManager()
    
    //async await
    func notifications(page: Int) async throws -> NotificationsModel {
        let path = NotificationsEndpoint.notifications.path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        let params: [String: Any] = ["page": page]
        
        return try await manager.request(path: path, model: NotificationsModel.self, method: .get, params: params, header: headers)
    }
}

