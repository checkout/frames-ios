import UIKit

public struct DefaultBillingFormPhoneNumberCellStyle: CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = .white
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.PhoneNumber.text)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(isHidden: false, text: Constants.LocalizationKeys.BillingForm.PhoneNumber.hint)
    public var textfield: ElementTextFieldStyle = DefaultTextField(isSupportingNumericKeyboard: true)
    public var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.PhoneNumber.error)

}
