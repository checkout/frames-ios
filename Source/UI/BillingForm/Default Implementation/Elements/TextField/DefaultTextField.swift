import UIKit

public struct DefaultTextField: ElementTextFieldStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var isHidden = false
    public var isSupportingNumericKeyboard = false
    public var text: String = ""
    public var placeholder: String?
    public var textColor: UIColor = FramesUIStyle.Color.textPrimary
    public var backgroundColor: UIColor = .clear
    public var tintColor: UIColor = FramesUIStyle.Color.textPrimary
    public var width: Double = Constants.Style.BillingForm.InputTextField.width.rawValue
    public var height: Double = Constants.Style.BillingForm.InputTextField.height.rawValue
    public var font = FramesUIStyle.Font.inputLabel

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

    internal var _cornerRadius: CGFloat = 10
    internal var _borderWidth: CGFloat = 1
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
