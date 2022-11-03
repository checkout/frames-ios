import UIKit

public struct DefaultTextField: ElementTextFieldStyle {
    public var isHidden = false
    public var isSupportingNumericKeyboard = false
    public var textAlignment: NSTextAlignment = .natural
    public var text: String = ""
    public var placeholder: String?
    public var textColor: UIColor = FramesUIStyle.Color.textPrimary
    public var backgroundColor: UIColor = .clear
    public var tintColor: UIColor = FramesUIStyle.Color.textPrimary
    public var width: Double = Constants.Style.BillingForm.InputTextField.width.rawValue
    public var height: Double = Constants.Style.BillingForm.InputTextField.height.rawValue
    public var font = FramesUIStyle.Font.inputLabel
    public var borderStyle: ElementBorderStyle = DefaultBorderStyle()
}

public struct DefaultBorderStyle: ElementBorderStyle {
    public var cornerRadius: CGFloat = 10
    public var borderWidth: CGFloat = 1.0
    public var normalBorderColor: UIColor = FramesUIStyle.Color.borderPrimary
    public var focusBorderColor: UIColor = FramesUIStyle.Color.borderActive
    public var errorBorderColor: UIColor = FramesUIStyle.Color.borderError
    public var sideBorders: [UIRectEdge] = [.all]
}
