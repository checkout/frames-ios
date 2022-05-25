import UIKit

struct DefaultTextField: ElementTextFieldStyle {
    var isHidden: Bool = false
    var text: String = ""
    var placeHolder: String = ""
    var isPlaceHolderHidden: Bool  = false
    var font: UIFont = UIFont(graphikStyle: .regular, size: Constants.Style.BillingForm.InputTextField.fontSize.rawValue)
    var textColor: UIColor = .codGray
    var normalBorderColor: UIColor = .mediumGray
    var focusBorderColor: UIColor = .brandeisBlue
    var errorBorderColor: UIColor = .tallPoppyRed
    var backgroundColor: UIColor = .white
    var tintColor: UIColor = .codGray
    var width: Double = Constants.Style.BillingForm.InputTextField.width.rawValue
    var height: Double = Constants.Style.BillingForm.InputTextField.height.rawValue
    var isSecured: Bool = false
    var isSupportingNumericKeyboard: Bool = false
}
