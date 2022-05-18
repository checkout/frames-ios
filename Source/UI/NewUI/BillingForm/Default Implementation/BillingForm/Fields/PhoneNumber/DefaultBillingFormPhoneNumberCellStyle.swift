import UIKit

struct DefaultBillingFormPhoneNumberCellStyle : CKOCellTextFieldStyle {
   
    var isOptional: Bool
    var backgroundColor: UIColor
    var title: CKOElementStyle?
    var hint: CKOElementStyle?
    var textfield: CKOElementTextFieldStyle
    var error: CKOElementErrorViewStyle
    
    init(isOptional: Bool = false,
         backgroundColor: UIColor = .white,
         header: CKOElementStyle = DefaultTitleLabelStyle(text: "phone".localized(forClass: CheckoutTheme.self)),
         hint: CKOElementStyle? = DefaultHintInputLabelStyle(isHidden: false,text: "billingFormPhoneNumberHint".localized(forClass: CheckoutTheme.self)),
         textfield: CKOElementTextFieldStyle = DefaultTextField(isSupprtingNumbericKeyboard: true),
         error: CKOElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCity".localized(forClass: CheckoutTheme.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
        self.isOptional = isOptional
    }
    
}
