import UIKit

struct DefaultBillingFormAddressLine2CellStyle : BillingFormTextFieldCellStyle {
    var backgroundColor: UIColor
    var title: InputLabelStyle?
    var hint: InputLabelStyle?
    var textfield: TextFieldStyle
    var error: ErrorInputLabelStyle
    
    init(backgroundColor: UIColor = .white,
         header: InputLabelStyle = DefaultTitleLabelStyle(text: "addressLine2".localized(forClass: DefaultBillingFormAddressLine2CellStyle.self)),
         hint: InputLabelStyle? = nil,
         textfield: TextFieldStyle = DefaultTextField(),
         error: ErrorInputLabelStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormAddressLine2".localized(forClass: DefaultBillingFormAddressLine2CellStyle.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
    }
    
}
