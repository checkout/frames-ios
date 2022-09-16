import Foundation
import UIKit

extension String {
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, bundle: Bundle.base, comment: "")
    }

    func image() -> UIImage {
        UIImage(named: self, in: Bundle.base, compatibleWith: nil) ?? UIImage()
    }

    func standardize() -> String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
}

private class Bundle {
    class var base: Foundation.Bundle {
#if SWIFT_PACKAGE
        let baseBundle = Bundle.module
#else
        let baseBundle = Foundation.Bundle(for: Bundle.self)
#endif
        guard let path = baseBundle.path(forResource: "Frames", ofType: "bundle") else { return baseBundle }
        guard let bundle = Foundation.Bundle(path: path) else { return baseBundle }
        return bundle
    }
}
