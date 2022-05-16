import UIKit

extension UIFont {
    
    // load framework font in application
    public static let loadAllCheckoutFonts: () = {
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

