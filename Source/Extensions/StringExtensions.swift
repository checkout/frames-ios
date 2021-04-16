import Foundation
import UIKit

extension String {

    private func getBundle(forClass: AnyClass) -> Foundation.Bundle {
        #if SWIFT_PACKAGE
        let baseBundle = Bundle.module
        #else
        let baseBundle = Foundation.Bundle(for: forClass)
        #endif
        let path = baseBundle.path(forResource: "Frames", ofType: "bundle")
        return path == nil ? baseBundle : Foundation.Bundle(path: path!)!
    }

    func localized(forClass: AnyClass, comment: String = "") -> String {
        let bundle = getBundle(forClass: forClass)
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }

    func image(forClass: AnyClass) -> UIImage {
        let bundle = getBundle(forClass: forClass)
        return UIImage(named: self, in: bundle, compatibleWith: nil) ?? UIImage()
    }
}
