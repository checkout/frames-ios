import Foundation
import UIKit

extension String {

    func getBundle(forClass: AnyClass) -> Foundation.Bundle {
#if SWIFT_PACKAGE
        let baseBundle = Bundle.module
#else
        let baseBundle = Foundation.Bundle(for: forClass)
#endif
        let path = baseBundle.path(forResource: "Frames", ofType: "bundle")
        // swiftlint:disable:next force_unwrapping
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

    func standardize() -> String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }

    // MARK: - register custom font to framework
    func registerFont(for type: AnyClass, withExtension: String) {
        let bundle = getBundle(forClass: type)

        guard let pathForResourceString = bundle.url(forResource: self, withExtension: withExtension) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }

        guard let fontData = NSData(contentsOf: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }

        guard let dataProvider = CGDataProvider.init(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }

        guard let fontRef = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }

        var errorRef: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}
