import UIKit

public struct DefaultBillingFormPhoneNumberCellStyle: CellTextFieldStyle {
    public var isMandatory = true
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.PhoneNumber.text)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(isHidden: false, text: Constants.LocalizationKeys.BillingForm.PhoneNumber.hint)
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = DefaultTextField(isSupportingNumericKeyboard: true)
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.PhoneNumber.error)
}
