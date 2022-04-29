import UIKit

struct DefaultBillingFormAddressLine1CellStyle : BillingFormTextFieldCellStyle {

    var type: BillingFormCellType
    var backgroundColor: UIColor
    var title: InputLabelStyle?
    var hint: InputLabelStyle?
    var textfield: TextFieldStyle
    var error: ErrorInputLabelStyle
    
    init(type: BillingFormCellType = .addressLine1,
         backgroundColor: UIColor = .white,
         header: InputLabelStyle = DefaultTitleLabelStyle(text: "addressLine1".localized(forClass: DefaultBillingFormAddressLine1CellStyle.self)),
         hint: InputLabelStyle? = nil,
         textfield: TextFieldStyle = DefaultTextField(),
         error: ErrorInputLabelStyle = DefaultErrorInputLabelStyle(text:  "missingBillingFormAddressLine1".localized(forClass: DefaultBillingFormAddressLine1CellStyle.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
        self.type = type
    }
    
}
