import UIKit

public struct DefaultHeaderLabelFormStyle: ElementStyle {
    public var backgroundColor: UIColor = .clear
    public var isHidden: Bool = false
    public var text: String = Constants.LocalizationKeys.BillingForm.Header.title
    public var font: UIFont = UIFont(graphikStyle: .medium, size: Constants.Style.BillingForm.HeaderTitle.fontSize.rawValue)
    public var textColor: UIColor  = .codGray
}
