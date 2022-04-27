import Foundation

// Header Cell
struct DefaultBillingFormHeaderCellStyle: BillingFormHeaderCellStyle {
    var headerLabel: InputLabelStyle
    var cancelButton: FormButtonStyle
    var doneButton: FormButtonStyle
    init(headerLabel: InputLabelStyle = DefaultHeaderLabelFormStyle(),
         cancelButton: FormButtonStyle = DefaultCancelButtonFormStyle(),
         doneButton: FormButtonStyle = DefaultDoneFormButtonStyle()) {
        self.headerLabel = headerLabel
        self.doneButton = doneButton
        self.cancelButton = cancelButton
    }
}
