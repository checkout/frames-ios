import UIKit

public struct DefaultDoneFormButtonStyle: ElementButtonStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var image: UIImage?
    public var text: String = Constants.LocalizationKeys.BillingForm.Header.done
    public var font = CKOUIStyle.Font.headline
    public var disabledTextColor: UIColor = CKOUIStyle.Color.textDisabled
    public var disabledTintColor: UIColor = CKOUIStyle.Color.actionDisabled
    public var activeTintColor: UIColor = CKOUIStyle.Color.actionPrimary
    public var backgroundColor: UIColor = .clear
    public var normalBorderColor: UIColor = .clear
    public var focusBorderColor: UIColor = .clear
    public var errorBorderColor: UIColor = .clear
    public var imageTintColor: UIColor = .clear
    public var textColor: UIColor = CKOUIStyle.Color.textActionSecondary
    public var isHidden = false
    public var isEnabled = true
    public var height: Double = Constants.Style.BillingForm.DoneButton.height.rawValue
    public var width: Double = Constants.Style.BillingForm.DoneButton.width.rawValue
    public var cornerRadius: CGFloat = 0
    public var borderWidth: CGFloat = 0
    public var textLeading: CGFloat = 0
}
