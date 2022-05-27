import UIKit

struct DefaultBillingFormAddressLine1CellStyle : CellTextFieldStyle {
    
    var isOptional: Bool = true
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.AddressLine1.title)
    var hint: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = DefaultTextField()
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text:  Constants.LocalizationKeys.BillingForm.AddressLine1.error)
}
