import UIKit

public struct DefaultHeaderLabelFormStyle: ElementStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var backgroundColor: UIColor = .clear
    public var isHidden = false
    public var text: String = Constants.LocalizationKeys.BillingForm.Header.title
    public var font = UIFont.systemFont(ofSize: Constants.Style.BillingForm.HeaderTitle.fontSize.rawValue)
    public var textColor: UIColor  = .codGray
}
