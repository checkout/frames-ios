import UIKit

struct DefaultHeaderLabelFormStyle: CKOElementStyle {
    var backgroundColor: UIColor
    var isHidden: Bool
    var text: String
    var font: UIFont
    var textColor: UIColor

    init(backgroundColor: UIColor = .clear,
         isHidden: Bool = false,
         text: String = "billingAddressTitle".localized(forClass: CheckoutTheme.self),
         font: UIFont = UIFont(graphikStyle: .medium, size: 24),
         textColor: UIColor = .codGray ) {
        self.backgroundColor = backgroundColor
        self.isHidden = isHidden
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
