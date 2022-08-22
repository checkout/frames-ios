import UIKit

public struct DefaultBillingFormStateCellStyle: CellTextFieldStyle {
    public var isMandatory = false
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: LocalizationKey.county.localizedValue)
    public var hint: ElementStyle?
    public var mandatory: ElementStyle? = DefaultTitleLabelStyle(
      backgroundColor: .clear,
      text: LocalizationKey.optional.localizedValue,
      font: UIFont.systemFont(ofSize: Constants.Style.BillingForm.InputOptionalLabel.fontSize.rawValue),
      textColor: .doveGray)
    public var textfield: ElementTextFieldStyle = DefaultTextField()
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: LocalizationKey.missingCounty.localizedValue)
}
