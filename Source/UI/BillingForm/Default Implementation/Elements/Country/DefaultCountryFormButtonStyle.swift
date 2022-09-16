import UIKit

public struct DefaultCountryFormButtonStyle: ElementButtonStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var image: UIImage? = Constants.Bundle.Images.rightArrow.image?.imageFlippedForRightToLeftLayoutDirection()
    public var text: String = Constants.LocalizationKeys.BillingForm.Country.text
    public var font = FramesUIStyle.Font.actionDefault
    public var disabledTextColor: UIColor = FramesUIStyle.Color.textDisabled
    public var disabledTintColor: UIColor = FramesUIStyle.Color.actionDisabled
    public var activeTintColor: UIColor = FramesUIStyle.Color.actionPrimary
    public var backgroundColor: UIColor = .clear
    public var textColor: UIColor = FramesUIStyle.Color.textSecondary
    public var normalBorderColor: UIColor = FramesUIStyle.Color.borderPrimary
    public var focusBorderColor: UIColor = FramesUIStyle.Color.borderActive
    public var errorBorderColor: UIColor = FramesUIStyle.Color.borderError
    public var imageTintColor: UIColor = FramesUIStyle.Color.iconAction
    public var isHidden = false
    public var isEnabled = true
    public var textLeading: CGFloat = Constants.Style.BillingForm.InputCountryButton.textLeading.rawValue
    public var height: Double = Constants.Style.BillingForm.InputCountryButton.height.rawValue
    public var width: Double = Constants.Style.BillingForm.InputCountryButton.width.rawValue
    public var cornerRadius: CGFloat = Constants.Style.BillingForm.InputCountryButton.cornerRadius.rawValue
    public var borderWidth: CGFloat = Constants.Style.BillingForm.InputCountryButton.borderWidth.rawValue
}
