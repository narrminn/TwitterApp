import Foundation
import Alamofire

enum EncodingType {
    case url
    case json
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
    let baseURL = "http://narminlt.beget.tech/api"
    let imageBaseURL = "http://narminlt.beget.tech"
    
    func configureURL(endpoint: String) -> String {
        return baseURL + "/" + endpoint
    }
}
