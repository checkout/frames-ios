import UIKit

public struct DefaultExpiryDateFormStyle: CellTextFieldStyle {
    public var isMandatory = true
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.PaymentForm.ExpiryDate.title)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: Constants.LocalizationKeys.PaymentForm.ExpiryDate.hint)
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = DefaultTextField(
        isSupportingNumericKeyboard: true,
        placeholder: Constants.LocalizationKeys.PaymentForm.ExpiryDate.placeholder)
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
}
