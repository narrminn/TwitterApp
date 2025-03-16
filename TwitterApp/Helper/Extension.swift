import UIKit
import Foundation
import Kingfisher

extension UIImageView {
    func loadImage(url: String) {
        let fullPath = NetworkHelper.shared.imageBaseURL + url
        guard let url = URL(string: fullPath) else { return }
        self.kf.setImage(with: url)
    }
}
