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
}
