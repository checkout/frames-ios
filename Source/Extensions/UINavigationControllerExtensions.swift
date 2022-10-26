import UIKit

extension UINavigationController {

    func copyStyle(from originalNavController: UINavigationController) {
        navigationBar.tintColor = originalNavController.navigationBar.tintColor
        let backgroundColor = originalNavController.navigationBar.backgroundColor
        navigationBar.backgroundColor = backgroundColor
        navigationBar.barTintColor = backgroundColor
        navigationBar.shadowImage = originalNavController.navigationBar.shadowImage
        navigationBar.titleTextAttributes = [ .foregroundColor: originalNavController.navigationBar.tintColor ?? .black]
        navigationBar.isTranslucent = true
        if #available(iOS 13.0, *) {
            navigationBar.standardAppearance = originalNavController.navigationBar.standardAppearance
            navigationBar.compactAppearance = originalNavController.navigationBar.compactAppearance
            navigationBar.scrollEdgeAppearance = originalNavController.navigationBar.scrollEdgeAppearance
        }
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
}
