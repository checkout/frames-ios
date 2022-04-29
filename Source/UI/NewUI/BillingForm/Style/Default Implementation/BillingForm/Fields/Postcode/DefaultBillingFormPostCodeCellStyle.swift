import UIKit

struct DefaultBillingFormPostcodeCellStyle : BillingFormTextFieldCellStyle {
    
    var type: BillingFormCellType
    var backgroundColor: UIColor
    var title: InputLabelStyle?
    var hint: InputLabelStyle?
    var textfield: TextFieldStyle
    var error: ErrorInputLabelStyle
    
    init(type: BillingFormCellType = .postcode,
         backgroundColor: UIColor = .white,
         header: InputLabelStyle = DefaultTitleLabelStyle(text: "postcode".localized(forClass: DefaultBillingFormPostcodeCellStyle.self)),
         hint: InputLabelStyle? = nil,
         textfield: TextFieldStyle = DefaultTextField(),
         error: ErrorInputLabelStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormPostcode".localized(forClass: DefaultBillingFormPostcodeCellStyle.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
        self.type = type
    }
    
}
