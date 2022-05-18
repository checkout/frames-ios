import UIKit

struct DefaultBillingFormAddressLine1CellStyle : CKOCellTextFieldStyle {
    
    var isOptional: Bool
    var backgroundColor: UIColor
    var title: CKOElementStyle?
    var hint: CKOElementStyle?
    var textfield: CKOElementTextFieldStyle
    var error: CKOElementErrorViewStyle
    
    init(isOptional: Bool = true,
         backgroundColor: UIColor = .white,
         header: CKOElementStyle = DefaultTitleLabelStyle(text: "addressLine1".localized(forClass: CheckoutTheme.self)),
         hint: CKOElementStyle? = nil,
         textfield: CKOElementTextFieldStyle = DefaultTextField(),
         error: CKOElementErrorViewStyle = DefaultErrorInputLabelStyle(text:  "missingBillingFormAddressLine1".localized(forClass: CheckoutTheme.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
        self.isOptional = isOptional
    }
    
}
