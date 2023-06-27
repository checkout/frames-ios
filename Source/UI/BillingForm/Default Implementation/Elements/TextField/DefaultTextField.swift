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
        get { borderStyle.cornerRadius }
        set { borderStyle.cornerRadius = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.borderWidth")
    public var borderWidth: CGFloat {
        get { borderStyle.borderWidth }
        set { borderStyle.borderWidth = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.normalColor")
    public var normalBorderColor: UIColor {
        get { borderStyle.normalColor }
        set { borderStyle.normalColor = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.focusColor")
    public var focusBorderColor: UIColor {
        get { borderStyle.focusColor }
        set { borderStyle.focusColor = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.errorColor")
    public var errorBorderColor: UIColor {
        get { borderStyle.errorColor }
        set { borderStyle.errorColor = newValue }
    }

    public var borderStyle: ElementBorderStyle = DefaultBorderStyle(cornerRadius: 10,
                                                                    borderWidth: 1,
                                                                    normalColor: FramesUIStyle.Color.borderPrimary,
                                                                    focusColor: FramesUIStyle.Color.borderActive,
                                                                    errorColor: FramesUIStyle.Color.borderError)
}
