import UIKit

struct DefaultTitleLabelStyle: CKOElementStyle {
    var backgroundColor: UIColor
    var isHidden: Bool
    var text: String
    var font: UIFont
    var textColor: UIColor
    
    init(backgroundColor: UIColor = .clear,
         isHidden: Bool = false,
         text: String = "",
         font: UIFont = UIFont(graphikStyle: .regular, size: 15),
         textColor: UIColor = .codGray) {
        self.backgroundColor = backgroundColor
        self.isHidden = isHidden
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
