import UIKit

struct DefaultBillingFormCountryCellStyle : BillingFormTextFieldCellStyle {
    var backgroundColor: UIColor
    var title: InputLabelStyle?
    var hint: InputLabelStyle?
    var textfield: TextFieldStyle
    var error: ErrorInputLabelStyle
    
    init(backgroundColor: UIColor = .white,
         header: InputLabelStyle = DefaultTitleLabelStyle(text: "country".localized(forClass: DefaultBillingFormCountryCellStyle.self)),
         hint: InputLabelStyle? = nil,
         textfield: TextFieldStyle = DefaultTextField(),
         error: ErrorInputLabelStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCountry".localized(forClass: DefaultBillingFormCountryCellStyle.self))) {
        self.backgroundColor = backgroundColor
        self.title = header
        self.hint = hint
        self.textfield = textfield
        self.error = error
    }
    
}
