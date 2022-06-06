import UIKit

struct DefaultTitleLabelStyle: CKOLabelStyle {
    var isHidden: Bool
    var text: String
    var font: UIFont
    var textColor: UIColor

    init(isHidden: Bool = false,
         text: String = "",
         font: UIFont = UIFont(graphikStyle: .regular, size: 15),
         textColor: UIColor = .codGray) {
        self.isHidden = isHidden
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
