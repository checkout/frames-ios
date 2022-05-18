import UIKit

struct DefaultErrorInputLabelStyle: CKOElementErrorViewStyle {
    var isHidden: Bool
    var backgroundColor: UIColor
    var tintColor: UIColor
    var text: String
    var font: UIFont
    var textColor: UIColor
    var isWarningImageOnLeft: Bool
    var height: Double
    
    init(isHidden: Bool = true,
         backgroundColor: UIColor = .white,
         tintColor: UIColor = .tallPoppyRed,
         text: String = "",
         font: UIFont = UIFont(graphikStyle: .medium, size: 13),
         textColor: UIColor =  .tallPoppyRed,
         isWarningImageOnLeft: Bool = true,
         height: Double = 18.0) {
        self.isHidden = isHidden
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.text = text
        self.font = font
        self.textColor = textColor
        self.isWarningImageOnLeft = isWarningImageOnLeft
        self.height = height
    }
}
