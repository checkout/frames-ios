import UIKit

public struct DefaultDoneFormButtonStyle: ElementButtonStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var image: UIImage?
    public var text: String = Constants.LocalizationKeys.BillingForm.Header.done
    public var font = UIStyle.Font.headline
    public var disabledTextColor: UIColor = UIStyle.Color.textDisabled
    public var disabledTintColor: UIColor = UIStyle.Color.actionDisabled
    public var activeTintColor: UIColor = UIStyle.Color.actionPrimary
    public var backgroundColor: UIColor = .clear
    public var normalBorderColor: UIColor = .clear
    public var focusBorderColor: UIColor = .clear
    public var errorBorderColor: UIColor = .clear
    public var imageTintColor: UIColor = .clear
    public var textColor: UIColor = UIStyle.Color.textActionSecondary
    public var isHidden = false
    public var isEnabled = true
    public var height: Double = Constants.Style.BillingForm.DoneButton.height.rawValue
    public var width: Double = Constants.Style.BillingForm.DoneButton.width.rawValue
    public var cornerRadius: CGFloat = 0
    public var borderWidth: CGFloat = 0
    public var textLeading: CGFloat = 0
}
