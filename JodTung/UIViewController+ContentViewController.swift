import UIKit

extension UIViewController {
    var contentViewController: UIViewController {
        if let contentViewController = (self as? UINavigationController)?.topViewController {
            return contentViewController
        }
        return self
    }
}
