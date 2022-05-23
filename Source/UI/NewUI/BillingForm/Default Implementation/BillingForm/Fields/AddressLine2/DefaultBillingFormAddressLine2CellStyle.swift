import UIKit

struct DefaultBillingFormAddressLine2CellStyle : CellTextFieldStyle {

    var isOptional: Bool = true
    var backgroundColor: UIColor = .clear
    var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.AddressLine2.title)
    var hint: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = DefaultTextField()
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.AddressLine2.error)
    
}
