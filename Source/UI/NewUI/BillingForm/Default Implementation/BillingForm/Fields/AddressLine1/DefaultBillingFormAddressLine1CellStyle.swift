import UIKit

struct DefaultBillingFormAddressLine1CellStyle : BillingFormTextFieldCellStyle {
    
    var isOptinal: Bool
    var backgroundColor: UIColor
    var title: InputLabelStyle?
    var hint: InputLabelStyle?
    var textfield: TextFieldStyle
    var error: ErrorInputLabelStyle
    
    init(isOptinal: Bool = true,
         backgroundColor: UIColor = .white,
         header: InputLabelStyle = DefaultTitleLabelStyle(text: "addressLine1".localized(forClass: CheckoutTheme.self)),
         hint: InputLabelStyle? = nil,
         textfield: TextFieldStyle = DefaultTextField(),
         error: ErrorInputLabelStyle = DefaultErrorInputLabelStyle(text:  "missingBillingFormAddressLine1".localized(forClass: CheckoutTheme.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
        self.isOptinal = isOptinal
    }
    
}
