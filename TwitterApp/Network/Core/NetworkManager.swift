import Foundation
import Alamofire
import UIKit

class NetworkManager {
    func request<T: Codable>(path: String,
                             model: T.Type,
                             method: HTTPMethod = .get,
                             params: Parameters? = nil,
                             encodingType: EncodingType = .url,
                             header: [String: String]? = nil,
                             completion: @escaping((T?, String?) -> Void)) {
        var headers: HTTPHeaders?
        
        if let paramHeader = header {
            headers = HTTPHeaders(paramHeader)
        }
        
        AF.request(path,
                   method: method,
                   parameters: params,
                   encoding: encodingType == .url ? URLEncoding.default : JSONEncoding.default,
                   headers: headers).responseDecodable(of: model.self) { response in
            let statusCode = response.response?.statusCode ?? 0
            
            if (statusCode >= 200 && statusCode < 300) {
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
            else if (statusCode == 500) {
                completion(nil, "Server error occured")
            }
            else {
                completion(nil, "Bad request")
            }
        }
    }
    
    func uploadPhoto<T: Codable>(path: String,
                                     model: T.Type,
                                     method: HTTPMethod = .post,
                                     photo: UIImage,
                                     header: [String: String]? = nil,
                                     completion: @escaping((T?, String?) -> Void)) {
        var headers: HTTPHeaders?
        
        if let paramHeader = header {
            headers = HTTPHeaders(paramHeader)
        }
        
        var imageData: Data?
        var mimeType = "image/jpeg"
        var fileName = "photo.jpg"
        
        if let jpegData = photo.jpegData(compressionQuality: 0.8) {
            imageData = jpegData
        } else if let pngData = photo.pngData() {
            imageData = pngData
            mimeType = "image/png"
            fileName = "photo.png"
        }

        guard let finalImageData = imageData else {
            completion(nil, "Failed to convert image to data")
            return
        }
        
        let multipartFormData = MultipartFormData()
                    
        multipartFormData.append(finalImageData, withName: "file", fileName: fileName, mimeType: mimeType)
        
        AF.upload(
            multipartFormData: multipartFormData,
            to: path,
            method: method,
            headers: headers
        )
        .responseDecodable(of: model.self) { response in
            let statusCode = response.response?.statusCode ?? 0

            if (statusCode >= 200 && statusCode < 300) {
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
            else if (statusCode == 500) {
                completion(nil, "Server error occured")
            }
            else {
                completion(nil, "Bad request")
            }
        }
    }
}
