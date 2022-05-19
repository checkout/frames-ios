import UIKit

struct DefaultBillingFormPostcodeCellStyle : CKOCellTextFieldStyle {
    
    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: CKOElementStyle? = DefaultTitleLabelStyle(text: "postcode".localized(forClass: CheckoutTheme.self))
    var hint: CKOElementStyle? = nil
    var textfield: CKOElementTextFieldStyle = DefaultTextField()
    var error: CKOElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormPostcode".localized(forClass: CheckoutTheme.self))
    
}
