import UIKit

public struct DefaultTextField: ElementTextFieldStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var isHidden = false
    public var isSupportingNumericKeyboard = false
    public var text: String = ""
    public var placeholder: String?
    public var textColor: UIColor = UIStyle.Color.textPrimary
    public var normalBorderColor: UIColor = UIStyle.Color.borderPrimary
    public var focusBorderColor: UIColor = UIStyle.Color.borderActive
    public var errorBorderColor: UIColor = UIStyle.Color.borderError
    public var backgroundColor: UIColor = .clear
    public var tintColor: UIColor = UIStyle.Color.textPrimary
    public var borderWidth: CGFloat = 1.0
    public var cornerRadius: CGFloat = 10.0
    public var width: Double = Constants.Style.BillingForm.InputTextField.width.rawValue
    public var height: Double = Constants.Style.BillingForm.InputTextField.height.rawValue
    public var font = UIStyle.Font.inputLabel
}
