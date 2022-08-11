import UIKit

public struct DefaultHintInputLabelStyle: ElementStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var backgroundColor: UIColor = .clear
    public var isHidden: Bool = false
    public var text: String = ""
    public var font: UIFont = UIFont.systemFont(ofSize: Constants.Style.BillingForm.InputHintLabel.fontSize.rawValue)
    public var textColor: UIColor = .doveGray
}
