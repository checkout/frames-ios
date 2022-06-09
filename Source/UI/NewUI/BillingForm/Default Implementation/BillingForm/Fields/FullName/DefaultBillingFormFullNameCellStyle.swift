import UIKit

public struct DefaultBillingFormFullNameCellStyle : CellTextFieldStyle {
    public var isMandatory: Bool = true
    public var backgroundColor: UIColor = .white
    public var title: ElementStyle? = DefaultTitleLabelStyle(text:  Constants.LocalizationKeys.BillingForm.FullName.text)
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = DefaultTextField()
    public var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.FullName.error)
}
