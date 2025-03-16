import UIKit
import Foundation

protocol Coordinator {
    var navigationController: UINavigationController { get }
    
    func start()
}
