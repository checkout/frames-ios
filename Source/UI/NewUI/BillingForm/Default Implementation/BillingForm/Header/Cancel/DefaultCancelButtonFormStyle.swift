import UIKit

struct DefaultCancelButtonFormStyle: CKOElementButtonStyle {
    var textColor: UIColor
    var isHidden: Bool
    var isEnabled: Bool
    var text: String
    var font: UIFont
    var activeTitleColor: UIColor
    var disabledTitleColor: UIColor
    var disabledTintColor: UIColor
    var activeTintColor: UIColor
    var backgroundColor: UIColor
    var height: Double
    var width: Double
    
    init( textColor: UIColor = .clear,
          isHidden: Bool = false,
          isEnabled: Bool = true,
          text: String = "cancel".localized(forClass: CheckoutTheme.self),
          font: UIFont =  UIFont.systemFont(ofSize: 17),
          activeTitleColor: UIColor = .brandeisBlue,
          disabledTitleColor: UIColor = .doveGray,
          disabledTintColor: UIColor = .doveGray,
          activeTintColor: UIColor = .brandeisBlue,
          backgroundColor: UIColor = .white,
          height: Double = 44,
          width: Double = 53) {
        self.textColor = textColor
        self.isHidden = isHidden
        self.isEnabled = isEnabled
        self.text = text
        self.font = font
        self.activeTitleColor = activeTitleColor
        self.disabledTitleColor = disabledTitleColor
        self.disabledTintColor = disabledTintColor
        self.activeTintColor = activeTintColor
        self.backgroundColor =  backgroundColor
        self.height = height
        self.width = width
    }
}
