import UIKit

struct DefaultBillingFormAddressLine1CellStyle : CellTextFieldStyle {
    
    var isOptional: Bool = true
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: "addressLine1".localized(forClass: CheckoutTheme.self))
    var hint: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = DefaultTextField()
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text:  "missingBillingFormAddressLine1".localized(forClass: CheckoutTheme.self))
    
}
