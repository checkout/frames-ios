import UIKit

public struct DefaultBillingFormStateCellStyle: CellTextFieldStyle {
    public var isMandatory: Bool = true
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.State.text)
    public var hint: ElementStyle?
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = DefaultTextField()
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.State.error)
}
