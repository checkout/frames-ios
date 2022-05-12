import UIKit

struct DefaultBillingFormHeaderCellStyle: BillingFormHeaderCellStyle {
    
    var backgroundColor: UIColor
    var headerLabel: InputLabelStyle
    var cancelButton: FormButtonStyle
    var doneButton: FormButtonStyle
    init(backgroundColor: UIColor = .white,
        headerLabel: InputLabelStyle = DefaultHeaderLabelFormStyle(),
         cancelButton: FormButtonStyle = DefaultCancelButtonFormStyle(),
         doneButton: FormButtonStyle = DefaultDoneFormButtonStyle()) {
        self.backgroundColor = backgroundColor
        self.headerLabel = headerLabel
        self.doneButton = doneButton
        self.cancelButton = cancelButton
    }
}
