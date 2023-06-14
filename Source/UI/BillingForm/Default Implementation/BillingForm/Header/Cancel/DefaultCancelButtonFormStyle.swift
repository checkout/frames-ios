import UIKit

public struct DefaultCancelButtonFormStyle: ElementButtonStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var image: UIImage?
    public var text: String = Constants.LocalizationKeys.BillingForm.Header.cancel
    public var font = FramesUIStyle.Font.headline
    public var disabledTextColor: UIColor = FramesUIStyle.Color.textDisabled
    public var disabledTintColor: UIColor = FramesUIStyle.Color.actionDisabled
    public var activeTintColor: UIColor = FramesUIStyle.Color.actionPrimary
    public var backgroundColor: UIColor = .clear
    public var imageTintColor: UIColor = .clear
    public var textColor: UIColor = FramesUIStyle.Color.textActionSecondary
    public var isHidden = false
    public var isEnabled = true
    public var height: Double = Constants.Style.BillingForm.CancelButton.height.rawValue
    public var width: Double = Constants.Style.BillingForm.CancelButton.width.rawValue
    public var textLeading: CGFloat = 0

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

    internal var _cornerRadius: CGFloat = 0
    internal var _borderWidth: CGFloat = 0
    internal var _normalBorderColor: UIColor = .clear
    internal var _focusBorderColor: UIColor = .clear
    internal var _errorBorderColor: UIColor = .clear

    public lazy var borderStyle: ElementBorderStyle = {
        DefaultBorderStyle(cornerRadius: _cornerRadius,
                           borderWidth: _borderWidth,
                           normalColor: _normalBorderColor,
                           focusColor: _focusBorderColor,
                           errorColor: _errorBorderColor)
    }()
}
