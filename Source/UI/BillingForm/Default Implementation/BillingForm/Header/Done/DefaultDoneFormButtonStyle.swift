import UIKit

public struct DefaultDoneFormButtonStyle: ElementButtonStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var image: UIImage?
    public var text: String = Constants.LocalizationKeys.BillingForm.Header.done
    public var font = FramesUIStyle.Font.headline
    public var disabledTextColor: UIColor = FramesUIStyle.Color.textDisabled
    public var disabledTintColor: UIColor = FramesUIStyle.Color.actionDisabled
    public var activeTintColor: UIColor = FramesUIStyle.Color.actionPrimary
    public var backgroundColor: UIColor = .clear
    public var imageTintColor: UIColor = .clear
    public var textColor: UIColor = FramesUIStyle.Color.textActionSecondary
    public var isHidden = false
    public var isEnabled = true
    public var height: Double = Constants.Style.BillingForm.DoneButton.height.rawValue
    public var width: Double = Constants.Style.BillingForm.DoneButton.width.rawValue
    public var textLeading: CGFloat = 0

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

    public var borderStyle: ElementBorderStyle = DefaultBorderStyle(cornerRadius: 0,
                                                                    borderWidth: 0,
                                                                    normalColor: .clear,
                                                                    focusColor: .clear,
                                                                    errorColor: .clear)
}
