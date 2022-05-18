import UIKit

struct DefaultBillingFormHeaderCellStyle: BillingFormHeaderCellStyle {
    
    var backgroundColor: UIColor
    var headerLabel: CKOElementStyle
    var cancelButton: CKOElementButtonStyle
    var doneButton: CKOElementButtonStyle
    init(backgroundColor: UIColor = .white,
        headerLabel: CKOElementStyle = DefaultHeaderLabelFormStyle(),
         cancelButton: CKOElementButtonStyle = DefaultCancelButtonFormStyle(),
         doneButton: CKOElementButtonStyle = DefaultDoneFormButtonStyle()) {
        self.backgroundColor = backgroundColor
        self.headerLabel = headerLabel
        self.doneButton = doneButton
        self.cancelButton = cancelButton
    }
}
