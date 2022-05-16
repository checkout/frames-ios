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

    func standardize() -> String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    //TODO: migrate to assets
    //https://www.hackingwithswift.com/example-code/core-graphics/how-to-render-a-pdf-to-an-image
    func vectorPDFImage(forClass: AnyClass) -> UIImage? {
        let bundle = getBundle(forClass: forClass)
        guard let urlPath = bundle.url(forResource: self, withExtension: "pdf") else { return nil }
        guard let document = CGPDFDocument(urlPath as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        
        return renderer.image {
            UIColor.white.set()
            $0.fill(pageRect)
            $0.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            $0.cgContext.scaleBy(x: 1.0, y: -1.0)
            $0.cgContext.drawPDFPage(page)
        }
    }
    
    //MARK: - Make custom font bundle register to framework
    func register(for type: AnyClass, withExtension: String) {
        let bundle = getBundle(forClass: type)
        
        if let pathForResourceString = bundle.url(forResource: self, withExtension: withExtension),
           let fontData = NSData(contentsOf: pathForResourceString), let dataProvider = CGDataProvider.init(data: fontData) {
            let fontRef = CGFont.init(dataProvider)
            var errorRef: Unmanaged<CFError>? = nil
            if CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false {
                print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
            }
        }
    }
    
}
