import UIKit

struct DefaultHintInputLabelStyle: CKOElementStyle {
    var backgroundColor: UIColor

    var isHidden: Bool
    var text: String
    var font: UIFont
    var textColor: UIColor
    
    init(backgroundColor: UIColor = .clear,
         isHidden: Bool = false,
         text: String = "",
         font: UIFont = UIFont(graphikStyle: .regular, size: 13),
         textColor: UIColor = .doveGray) {
        self.backgroundColor = backgroundColor
        self.isHidden = isHidden
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
