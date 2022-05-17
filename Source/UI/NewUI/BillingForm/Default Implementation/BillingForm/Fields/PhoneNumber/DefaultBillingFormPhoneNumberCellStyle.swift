import UIKit

struct DefaultBillingFormPhoneNumberCellStyle : CKOTextFieldCellStyle {
   
    var isOptional: Bool
    var backgroundColor: UIColor
    var title: CKOLabelStyle?
    var hint: CKOLabelStyle?
    var textfield: CKOTextFieldStyle
    var error: CKOErrorLabelStyle
    
    init(isOptional: Bool = false,
         backgroundColor: UIColor = .white,
         header: CKOLabelStyle = DefaultTitleLabelStyle(text: "phone".localized(forClass: CheckoutTheme.self)),
         hint: CKOLabelStyle? = DefaultHintInputLabelStyle(isHidden: false,text: "billingFormPhoneNumberHint".localized(forClass: CheckoutTheme.self)),
         textfield: CKOTextFieldStyle = DefaultTextField(isSupprtingNumbericKeyboard: true),
         error: CKOErrorLabelStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCity".localized(forClass: CheckoutTheme.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
        self.isOptional = isOptional
    }
    
}
