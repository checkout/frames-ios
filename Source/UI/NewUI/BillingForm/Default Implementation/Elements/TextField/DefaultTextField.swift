import UIKit

public struct DefaultTextField: ElementTextFieldStyle {
    public var isHidden: Bool = false
    public var text: String = ""
    public var placeHolder: String = ""
    public var isPlaceHolderHidden: Bool  = false
    public var font: UIFont = UIFont(graphikStyle: .regular, size: Constants.Style.BillingForm.InputTextField.fontSize.rawValue)
    public var textColor: UIColor = .codGray
    public var normalBorderColor: UIColor = .mediumGray
    public var focusBorderColor: UIColor = .brandeisBlue
    public var errorBorderColor: UIColor = .tallPoppyRed
    public var backgroundColor: UIColor = .clear
    public var tintColor: UIColor = .codGray
    public var width: Double = Constants.Style.BillingForm.InputTextField.width.rawValue
    public var height: Double = Constants.Style.BillingForm.InputTextField.height.rawValue
    public var isSecured: Bool = false
    public var isSupportingNumericKeyboard: Bool = false
}
