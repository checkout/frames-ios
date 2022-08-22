import UIKit

public struct DefaultBillingFormPhoneNumberCellStyle: CellTextFieldStyle {
    public var isMandatory = true
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: LocalizationKey.phoneNumber.localizedValue)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(
        isHidden: false,
        text: LocalizationKey.phoneNumberHint.localizedValue)
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = DefaultTextField(isSupportingNumericKeyboard: true)
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: LocalizationKey.missingPhoneNumber.localizedValue)
}
