import UIKit

struct DefaultBillingFormStateCellStyle : CKOCellTextFieldStyle {
    
    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: CKOElementStyle? = DefaultTitleLabelStyle(text:  "countryRegion".localized(forClass: CheckoutTheme.self))
    var hint: CKOElementStyle? = nil
    var textfield: CKOElementTextFieldStyle = DefaultTextField()
    var error: CKOElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormState".localized(forClass: CheckoutTheme.self))
    
}
