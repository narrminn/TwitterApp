import Foundation
import Alamofire

class NetworkManager {
    func request<T: Codable>(path: String,
                             model: T.Type,
                             method: HTTPMethod = .get,
                             params: Parameters? = nil,
                             encodingType: EncodingType = .url,
                             header: HTTPHeaders? = nil,
                             completion: @escaping((T?, String?) -> Void)) {
        AF.request(path,
                   method: method,
                   parameters: params,
                   encoding: encodingType == .url ? URLEncoding.default : JSONEncoding.default,
                   headers: header).responseDecodable(of: model.self) { response in
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
