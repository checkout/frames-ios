import UIKit

struct DefaultFormStylePhoneNumberCell : BillingFormTextFieldCellStyle {
    var backgroundColor: UIColor
    var title: InputLabelStyle?
    var hint: InputLabelStyle?
    var textfield: TextFieldStyle
    var error: ErrorInputLabelStyle
    
    init(backgroundColor: UIColor = .white,
         header: InputLabelStyle = DefaultTitleLabelStyle(text: "Phone number"),
         hint: InputLabelStyle? = DefaultHintInputLabelStyle(isHidden: false,
                                                             text: "We will only use this to confirm identity if neccessary"),
         textfield: TextFieldStyle = DefaultTextField(isSupprtingNumbericKeyboard: true),
         error: ErrorInputLabelStyle = DefaultErrorInputLabelStyle(text: "missing Phone number")) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
    }
    
}
