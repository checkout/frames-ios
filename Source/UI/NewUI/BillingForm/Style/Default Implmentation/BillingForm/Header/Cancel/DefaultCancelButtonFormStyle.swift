import UIKit

struct DefaultCancelButtonFormStyle: FormButtonStyle {
    var isEnabled: Bool
    var text: String
    var font: UIFont
    var activeTitleColor: UIColor
    var inActiveTitleColor: UIColor
    var inActiveTintColor: UIColor
    var activeTintColor: UIColor
    var backgroundColor: UIColor
    var hight: Double
    var width: Double
    
    init( isEnabled: Bool = true,
          text: String = "Cancel",
          font: UIFont = UIFont.systemFont(ofSize: 17),
          activeTitleColor: UIColor = .brandeisBlue,
          inActiveTitleColor: UIColor = .doveGray,
          inActiveTintColor: UIColor = .doveGray,
          activeTintColor: UIColor = .brandeisBlue,
          backgroundColor: UIColor = .white,
          hight: Double = 44,
          width: Double = 53) {
        self.isEnabled = isEnabled
        self.text = text
        self.font = font
        self.activeTitleColor = activeTitleColor
        self.inActiveTitleColor = inActiveTitleColor
        self.inActiveTintColor = inActiveTintColor
        self.activeTintColor = activeTintColor
        self.backgroundColor =  backgroundColor
        self.hight = hight
        self.width = width
    }
}
