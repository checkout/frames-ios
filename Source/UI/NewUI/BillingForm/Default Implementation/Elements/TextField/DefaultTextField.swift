import UIKit

struct DefaultTextField: CKOTextFieldStyle {
    var text: String
    var placeHolder: String
    var isPlaceHolderHidden: Bool
    var font: UIFont
    var textColor: UIColor
    var normalBorderColor: UIColor
    var focusBorderColor: UIColor
    var errorBorderColor: UIColor
    var backgroundColor: UIColor
    var tintColor: UIColor
    var width: Double
    var height: Double
    var isSecured: Bool
    var isSupprtingNumbericKeyboard: Bool
    
    init(text: String = "",
         placeHolder: String = "",
         isPlaceHolderHidden: Bool  = false,
         font: UIFont = UIFont(graphikStyle: .regular, size: 16),
         textColor: UIColor = .codGray,
         normalBorderColor: UIColor = .mediumGray,
         focusBorderColor: UIColor = .brandeisBlue,
         errorBorderColor: UIColor = .tallPoppyRed,
         backgroundColor: UIColor = .white,
         tintColor: UIColor = .codGray,
         width: Double = 335.0,
         height: Double = 56.0,
         isSecured: Bool = false,
         isSupprtingNumbericKeyboard: Bool = false) {
        self.text = text
        self.placeHolder = placeHolder
        self.isPlaceHolderHidden = isPlaceHolderHidden
        self.font = font
        self.textColor = textColor
        self.normalBorderColor = normalBorderColor
        self.focusBorderColor = focusBorderColor
        self.errorBorderColor = errorBorderColor
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.width = width
        self.height = height
        self.isSecured = isSecured
        self.isSupprtingNumbericKeyboard = isSupprtingNumbericKeyboard
    }
}
