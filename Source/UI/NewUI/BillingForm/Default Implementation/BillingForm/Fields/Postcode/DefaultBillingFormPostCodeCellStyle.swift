import UIKit

struct DefaultBillingFormPostcodeCellStyle : CellTextFieldStyle {
    
    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: "postcode".localized(forClass: CheckoutTheme.self))
    var hint: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = DefaultTextField()
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormPostcode".localized(forClass: CheckoutTheme.self))
    
}
