import Foundation
import UIKit

extension String {

    private func getBundle(forClass: AnyClass) -> Bundle {
        let baseBundle = Bundle(for: forClass)
        let path = baseBundle.path(forResource: "FramesIos", ofType: "bundle")
        return path == nil ? baseBundle : Bundle(path: path!)!
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
