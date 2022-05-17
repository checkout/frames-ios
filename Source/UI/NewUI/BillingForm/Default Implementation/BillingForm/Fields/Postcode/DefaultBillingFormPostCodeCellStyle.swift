import UIKit

struct DefaultBillingFormPostcodeCellStyle : CKOTextFieldCellStyle {
    
    var isOptional: Bool
    var backgroundColor: UIColor
    var title: CKOLabelStyle?
    var hint: CKOLabelStyle?
    var textfield: CKOTextFieldStyle
    var error: CKOErrorLabelStyle
    
    init(isOptional: Bool = false,
         backgroundColor: UIColor = .white,
         header: CKOLabelStyle = DefaultTitleLabelStyle(text: "postcode".localized(forClass: CheckoutTheme.self)),
         hint: CKOLabelStyle? = nil,
         textfield: CKOTextFieldStyle = DefaultTextField(),
         error: CKOErrorLabelStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormPostcode".localized(forClass: CheckoutTheme.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
        self.isOptional = isOptional
    }
    
}
