import UIKit

public struct DefaultTitleLabelStyle: ElementStyle {
    public var backgroundColor: UIColor = .clear
    public var isHidden: Bool = false
    public var text: String = ""
    public var font: UIFont = UIFont.systemFont(ofSize: Constants.Style.BillingForm.InputTitleLabel.fontSize.rawValue)
    public var textColor: UIColor = .codGray
}
