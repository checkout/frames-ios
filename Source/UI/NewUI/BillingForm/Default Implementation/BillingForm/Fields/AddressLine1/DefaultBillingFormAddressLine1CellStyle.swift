import UIKit

public struct DefaultBillingFormAddressLine1CellStyle : CellTextFieldStyle {
    public var isOptional: Bool = false
    public var backgroundColor: UIColor = .white
    public var title: ElementStyle? = DefaultTitleLabelStyle(text:  Constants.LocalizationKeys.BillingForm.AddressLine1.title)
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = DefaultTextField()
    public var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text:  Constants.LocalizationKeys.BillingForm.AddressLine1.error)
}
