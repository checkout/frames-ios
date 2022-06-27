import UIKit

extension UIFont {

    // load framework font in application
    public static let loadAllCheckoutFonts: () = {
        for style in GraphikStyle.allCases {
            style.fontName.registerFont(for: CheckoutTheme.self, withExtension: "otf")
        }
    }()

}

extension UIFont {

    enum GraphikStyle: String, CaseIterable {
        case black = "Black"
        case blackItalic = "BlackItalic"

        case bold = "Bold"
        case boldItalic = "BoldItalic"

        case extraLight = "Extralight"
        case extraLightItalic = "ExtralightItalic"

        case light = "Light"
        case lightItalic = "LightItalic"

        case medium = "Medium"
        case mediumItalic = "MediumItalic"

        case regular = "Regular"
        case regularItalic = "RegularItalic"

        case semibold = "Semibold"
        case semiboldItalic = "SemiboldItalic"

        case `super` = "Super"
        case `superItalic` = "SuperItalic"

        case thin = "Thin"
        case thinItalic = "ThinItalic"

        var fontName: String {
            return "GraphikLCG-\(self.rawValue)"
        }
    }

    convenience init(graphikStyle: GraphikStyle, size: CGFloat) {
        self.init(name: graphikStyle.fontName, size: size)!
    }

}
