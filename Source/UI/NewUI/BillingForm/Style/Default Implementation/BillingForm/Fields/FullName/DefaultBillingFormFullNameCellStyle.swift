import UIKit

struct DefaultBillingFormFullNameCellStyle : BillingFormTextFieldCellStyle {
    var backgroundColor: UIColor
    var title: InputLabelStyle?
    var hint: InputLabelStyle?
    var textfield: TextFieldStyle
    var error: ErrorInputLabelStyle
    
    init(backgroundColor: UIColor = .white,
         header: InputLabelStyle = DefaultTitleLabelStyle(text: "name".localized(forClass: DefaultBillingFormFullNameCellStyle.self)),
         hint: InputLabelStyle? = nil,
         textfield: TextFieldStyle = DefaultTextField(),
         error: ErrorInputLabelStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCityFullName".localized(forClass: DefaultBillingFormFullNameCellStyle.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
    }
    
}
