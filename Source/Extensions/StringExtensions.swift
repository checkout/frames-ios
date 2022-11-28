import Foundation
import UIKit

extension String {
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, bundle: FramesBundle.base, comment: comment)
    }

    func image() -> UIImage {
        UIImage(named: self, in: FramesBundle.base, compatibleWith: nil) ?? UIImage()
    }

    func standardize() -> String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
}

private class FramesBundle {
    class var base: Foundation.Bundle {
#if SWIFT_PACKAGE
        let baseBundle = Bundle.module
#else
        let baseBundle = Foundation.Bundle(for: FramesBundle.self)
#endif
        guard let path = baseBundle.path(forResource: "Frames", ofType: "bundle") else { return baseBundle }
        guard let bundle = Foundation.Bundle(path: path) else { return baseBundle }
        return bundle
    }
}
