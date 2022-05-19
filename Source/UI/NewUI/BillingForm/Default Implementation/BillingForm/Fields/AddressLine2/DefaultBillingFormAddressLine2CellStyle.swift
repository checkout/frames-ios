import UIKit

struct DefaultBillingFormAddressLine2CellStyle : CellTextFieldStyle {

    var isOptional: Bool = true
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: "addressLine2".localized(forClass: CheckoutTheme.self))
    var hint: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = DefaultTextField()
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormAddressLine2".localized(forClass: CheckoutTheme.self))
    
}
