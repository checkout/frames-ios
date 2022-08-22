import Foundation
import UIKit

class BundleIdentifier {
    static func getBundle() -> Foundation.Bundle {
    #if SWIFT_PACKAGE
        let baseBundle = Bundle.module
    #else
        let baseBundle = Foundation.Bundle(for: Self.self)
    #endif
        guard let path = baseBundle.path(forResource: "Frames", ofType: "bundle") else { return baseBundle }
        guard let bundle = Foundation.Bundle(path: path) else { return baseBundle }
        return bundle
    }
}

extension String {
    func localized(comment: String = "") -> String {
        let bundle = BundleIdentifier.getBundle()
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }

    func image() -> UIImage {
        let bundle = BundleIdentifier.getBundle()
        return UIImage(named: self, in: bundle, compatibleWith: nil) ?? UIImage()
    }

    func standardize() -> String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
}
