import UIKit

public struct DefaultBillingFormPostcodeCellStyle: CellTextFieldStyle {
    public var isMandatory = true
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.Postcode.text)
    public var hint: ElementStyle?
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = DefaultTextField()
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.Postcode.error)
}
