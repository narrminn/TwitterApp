import Foundation
import UIKit

protocol FileManagerUseCase {
    func fileUpload(file: UIImage, completion: @escaping((FileUploadModel?, String?) -> Void))
}

class FileNetworkManager: FileManagerUseCase {
    var manager = NetworkManager()
    
    func fileUpload(file: UIImage, completion: @escaping((FileUploadModel?, String?) -> Void)) {
        let path = FileEndpoint.fileUpload.path
        
        let headers = [
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.uploadPhoto(path: path, model: FileUploadModel.self, method: .post, photo: file, header: headers, completion: completion)
    }
}

