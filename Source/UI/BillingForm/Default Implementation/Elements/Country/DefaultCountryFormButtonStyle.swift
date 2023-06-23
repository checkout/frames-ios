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
    public var imageTintColor: UIColor = FramesUIStyle.Color.iconAction
    public var isHidden = false
    public var isEnabled = true
    public var textLeading: CGFloat = Constants.Style.BillingForm.InputCountryButton.textLeading.rawValue
    public var height: Double = Constants.Style.BillingForm.InputCountryButton.height.rawValue
    public var width: Double = Constants.Style.BillingForm.InputCountryButton.width.rawValue

    @available(*, deprecated, renamed: "borderStyle.cornerRadius")
    public var cornerRadius: CGFloat {
        get { _cornerRadius }
        set { _cornerRadius = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.borderWidth")
    public var borderWidth: CGFloat {
        get { _borderWidth }
        set { _borderWidth = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.normalColor")
    public var normalBorderColor: UIColor {
        get { _normalBorderColor }
        set { _normalBorderColor = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.focusColor")
    public var focusBorderColor: UIColor {
        get { _focusBorderColor }
        set { _focusBorderColor = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.errorColor")
    public var errorBorderColor: UIColor {
        get { _errorBorderColor }
        set { _errorBorderColor = newValue }
    }

    internal var _cornerRadius: CGFloat = Constants.Style.BorderStyle.cornerRadius
    internal var _borderWidth: CGFloat = Constants.Style.BorderStyle.borderWidth
    internal var _normalBorderColor: UIColor = FramesUIStyle.Color.borderPrimary
    internal var _focusBorderColor: UIColor = FramesUIStyle.Color.borderActive
    internal var _errorBorderColor: UIColor = FramesUIStyle.Color.borderError

    public lazy var borderStyle: ElementBorderStyle = {
        DefaultBorderStyle(cornerRadius: _cornerRadius,
                           borderWidth: _borderWidth,
                           normalColor: _normalBorderColor,
                           focusColor: _focusBorderColor,
                           errorColor: _errorBorderColor)
    }()
}
