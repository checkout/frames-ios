import UIKit

struct DefaultBillingFormFullNameCellStyle : CKOCellTextFieldStyle {
    
    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: CKOElementStyle? = DefaultTitleLabelStyle(text: "name".localized(forClass: CheckoutTheme.self))
    var hint: CKOElementStyle? = nil
    var textfield: CKOElementTextFieldStyle = DefaultTextField()
    var error: CKOElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormFullName".localized(forClass: CheckoutTheme.self))
}
