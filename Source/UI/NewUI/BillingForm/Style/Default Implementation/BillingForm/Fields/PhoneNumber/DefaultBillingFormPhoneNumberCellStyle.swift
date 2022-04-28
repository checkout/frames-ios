import UIKit

struct DefaultBillingFormPhoneNumberCellStyle : BillingFormTextFieldCellStyle {
    var backgroundColor: UIColor
    var title: InputLabelStyle?
    var hint: InputLabelStyle?
    var textfield: TextFieldStyle
    var error: ErrorInputLabelStyle
    
    init(backgroundColor: UIColor = .white,
         header: InputLabelStyle = DefaultTitleLabelStyle(text: "phone".localized(forClass: DefaultBillingFormPhoneNumberCellStyle.self)),
         hint: InputLabelStyle? = DefaultHintInputLabelStyle(isHidden: false,text: "billingFormPhoneNumberHint".localized(forClass: DefaultBillingFormPhoneNumberCellStyle.self)),
         textfield: TextFieldStyle = DefaultTextField(isSupprtingNumbericKeyboard: true),
         error: ErrorInputLabelStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCity".localized(forClass: DefaultBillingFormPhoneNumberCellStyle.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
    }
    
}
