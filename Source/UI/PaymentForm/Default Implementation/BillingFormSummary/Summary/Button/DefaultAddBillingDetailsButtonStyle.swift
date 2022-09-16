import UIKit

public final class DefaultAddBillingDetailsButtonStyle: ElementButtonStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var image: UIImage? = Constants.Bundle.Images.rightArrow.image?.imageFlippedForRightToLeftLayoutDirection()
    public var text: String = Constants.LocalizationKeys.PaymentForm.BillingSummary.addBillingAddress
    public var font = UIStyle.Font.actionDefault
    public var textColor: UIColor = UIStyle.Color.textActionPrimary
    public var disabledTextColor: UIColor = UIStyle.Color.textDisabled
    public var disabledTintColor: UIColor = UIStyle.Color.actionDisabled
    public var activeTintColor: UIColor = UIStyle.Color.actionPrimary
    public var backgroundColor: UIColor = .clear
    public var normalBorderColor: UIColor = UIStyle.Color.borderActive
    public var focusBorderColor: UIColor = UIStyle.Color.borderActive
    public var errorBorderColor: UIColor = UIStyle.Color.borderError
    public var imageTintColor: UIColor = UIStyle.Color.iconAction
    public var isHidden = false
    public var isEnabled = true
    public var height: Double = Constants.Style.PaymentForm.InputBillingFormButton.height.rawValue
    public var width: Double = Constants.Style.PaymentForm.InputBillingFormButton.width.rawValue
    public var cornerRadius: CGFloat = Constants.Style.PaymentForm.InputBillingFormButton.cornerRadius.rawValue
    public var borderWidth: CGFloat = Constants.Style.PaymentForm.InputBillingFormButton.borderWidth.rawValue
    public var textLeading: CGFloat = Constants.Style.PaymentForm.InputBillingFormButton.textLeading.rawValue
}
