import UIKit

struct DefaultBillingFormFullNameCellStyle : CKOCellTextFieldStyle {
    
    var isOptional: Bool
    var backgroundColor: UIColor
    var title: CKOElementStyle?
    var hint: CKOElementStyle?
    var textfield: CKOElementTextFieldStyle
    var error: CKOElementErrorViewStyle
    
    init(isOptional: Bool = false,
         backgroundColor: UIColor = .white,
         header: CKOElementStyle = DefaultTitleLabelStyle(text: "name".localized(forClass: CheckoutTheme.self)),
         hint: CKOElementStyle? = nil,
         textfield: CKOElementTextFieldStyle = DefaultTextField(),
         error: CKOElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormFullName".localized(forClass: CheckoutTheme.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
        self.isOptional = isOptional
    }
    
}
