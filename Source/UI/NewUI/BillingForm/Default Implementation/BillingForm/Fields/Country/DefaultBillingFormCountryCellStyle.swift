import UIKit

struct DefaultBillingFormCountryCellStyle : CKOCellTextFieldStyle {
    
    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: CKOElementStyle? = DefaultTitleLabelStyle(text: "country".localized(forClass: CheckoutTheme.self))
    var hint: CKOElementStyle? = nil
    var textfield: CKOElementTextFieldStyle = DefaultTextField()
    var error: CKOElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCountry".localized(forClass: CheckoutTheme.self))
    
}
