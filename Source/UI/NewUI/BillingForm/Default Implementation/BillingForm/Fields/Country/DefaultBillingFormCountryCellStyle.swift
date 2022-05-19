import UIKit

struct DefaultBillingFormCountryCellStyle : CellTextFieldStyle {
    
    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: "country".localized(forClass: CheckoutTheme.self))
    var hint: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = DefaultTextField()
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCountry".localized(forClass: CheckoutTheme.self))
    
}
