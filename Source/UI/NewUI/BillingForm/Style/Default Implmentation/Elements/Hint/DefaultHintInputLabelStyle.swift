import UIKit

// hint element
struct DefaultHintInputLabelStyle: InputLabelStyle {
    var isHidden: Bool
    var text: String
    var font: UIFont
    var textColor: UIColor
    
    init(isHidden: Bool = false,
         text: String = "",
         font: UIFont = UIFont.systemFont(ofSize: 13),
         textColor: UIColor = .doveGray) {
        self.isHidden = isHidden
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
