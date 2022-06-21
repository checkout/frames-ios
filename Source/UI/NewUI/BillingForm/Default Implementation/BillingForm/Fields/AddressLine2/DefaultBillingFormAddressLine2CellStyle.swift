import UIKit

public struct DefaultBillingFormAddressLine2CellStyle : CellTextFieldStyle {
    public var isMandatory: Bool = false
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text:  Constants.LocalizationKeys.BillingForm.AddressLine2.title)
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = DefaultTextField()
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.AddressLine2.error)
}
