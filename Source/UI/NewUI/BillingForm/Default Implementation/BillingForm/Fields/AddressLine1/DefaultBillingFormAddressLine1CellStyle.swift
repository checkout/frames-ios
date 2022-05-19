import UIKit

struct DefaultBillingFormAddressLine1CellStyle : CKOCellTextFieldStyle {
    
    var isOptional: Bool = true
    var backgroundColor: UIColor = .white
    var title: CKOElementStyle? = DefaultTitleLabelStyle(text: "addressLine1".localized(forClass: CheckoutTheme.self))
    var hint: CKOElementStyle? = nil
    var textfield: CKOElementTextFieldStyle = DefaultTextField()
    var error: CKOElementErrorViewStyle = DefaultErrorInputLabelStyle(text:  "missingBillingFormAddressLine1".localized(forClass: CheckoutTheme.self))
    
}
