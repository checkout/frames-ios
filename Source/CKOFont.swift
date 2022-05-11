import UIKit

extension UIFont {
    
    // load framework font in application
    public static let loadAllFonts: () = {
        for style in GraphikStyle.allCases {
            style.fontName.register(for: CheckoutTheme.self, withExtension: "otf")
        }
    }()
    
}

extension UIFont {

    enum GraphikStyle: String, CaseIterable {
        case regularIt
        case thin
        case thinIt
        case extrabldIt
        case lightIt
        case black
        case medium
        case extrabld
        case boldIt
        case regular
        case blackIt
        case mediumIt
        case bold
        case light
        case semiboldIt
        case semibold
        var fontName: String {
            return "GraphikLCG-\(self.rawValue.capitalized)"
        }
    }
    
    convenience init(graphikStyle: GraphikStyle, size: CGFloat) {
        self.init(name: graphikStyle.fontName, size: size)!
    }

}


extension String {
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
