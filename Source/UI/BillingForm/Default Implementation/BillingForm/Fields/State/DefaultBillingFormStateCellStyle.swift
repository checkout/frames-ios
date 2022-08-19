import UIKit

public struct DefaultBillingFormStateCellStyle: CellTextFieldStyle {
    public var isMandatory: Bool = false
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.State.text)
    public var hint: ElementStyle?
    public var mandatory: ElementStyle? = DefaultTitleLabelStyle(
      backgroundColor: .clear,
      text: Constants.LocalizationKeys.optionalInput,
      font: UIFont.systemFont(ofSize: Constants.Style.BillingForm.InputOptionalLabel.fontSize.rawValue),
      textColor: .doveGray)
    public var textfield: ElementTextFieldStyle = DefaultTextField()
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.State.error)
}
