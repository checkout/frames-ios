import UIKit

public struct DefaultExpiryDateFormStyle: CellTextFieldStyle {
    public var isMandatory = true
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: LocalizationKey.expiryDate.localizedValue)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: LocalizationKey.formatMMYY.localizedValue)
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = DefaultTextField(
        isSupportingNumericKeyboard: true,
        placeholder: LocalizationKey.emptyFormat.localizedValue)
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: LocalizationKey.expiryDateInvalid.localizedValue)
}
