import UIKit

public struct DefaultTitleLabelStyle: ElementStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var backgroundColor: UIColor = .clear
    public var isHidden = false
    public var text: String = ""
    public var font = UIFont.systemFont(ofSize: Constants.Style.BillingForm.InputTitleLabel.fontSize.rawValue)
    public var textColor: UIColor = .codGray
}
