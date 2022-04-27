import UIKit

struct DefaultErrorInputLabelStyle: ErrorInputLabelStyle {
    var isHidden: Bool
    var backgroundColor: UIColor
    var tintColor: UIColor
    var text: String
    var font: UIFont
    var textColor: UIColor
    var isWarningSympoleOnLeft: Bool
    var height: Double
    
    init(isHidden: Bool = true,
         backgroundColor: UIColor = .white,
         tintColor: UIColor = .tallPoppyRed,
         text: String = "",
         font: UIFont = UIFont.systemFont(ofSize: 15),
         textColor: UIColor =  .tallPoppyRed,
         isWarningSympoleOnLeft: Bool = true,
         height: Double = 18.0) {
        self.isHidden = isHidden
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.text = text
        self.font = font
        self.textColor = textColor
        self.isWarningSympoleOnLeft = isWarningSympoleOnLeft
        self.height = height
    }
}
