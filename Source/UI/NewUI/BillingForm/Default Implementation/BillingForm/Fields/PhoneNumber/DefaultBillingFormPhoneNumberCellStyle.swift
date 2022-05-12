import UIKit

struct DefaultBillingFormPhoneNumberCellStyle : BillingFormTextFieldCellStyle {
   
    var isOptinal: Bool
    var backgroundColor: UIColor
    var title: InputLabelStyle?
    var hint: InputLabelStyle?
    var textfield: TextFieldStyle
    var error: ErrorInputLabelStyle
    
    init(isOptinal: Bool = false,
         backgroundColor: UIColor = .white,
         header: InputLabelStyle = DefaultTitleLabelStyle(text: "phone".localized(forClass: CheckoutTheme.self)),
         hint: InputLabelStyle? = DefaultHintInputLabelStyle(isHidden: false,text: "billingFormPhoneNumberHint".localized(forClass: CheckoutTheme.self)),
         textfield: TextFieldStyle = DefaultTextField(isSupprtingNumbericKeyboard: true),
         error: ErrorInputLabelStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCity".localized(forClass: CheckoutTheme.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
        self.isOptinal = isOptinal
    }
    
}
