import UIKit

struct DefaultBillingFormHeaderCellStyle: BillingFormHeaderCellStyle {
    
    var backgroundColor: UIColor
    var headerLabel: CKOLabelStyle
    var cancelButton: CKOButtonStyle
    var doneButton: CKOButtonStyle
    init(backgroundColor: UIColor = .white,
        headerLabel: CKOLabelStyle = DefaultHeaderLabelFormStyle(),
         cancelButton: CKOButtonStyle = DefaultCancelButtonFormStyle(),
         doneButton: CKOButtonStyle = DefaultDoneFormButtonStyle()) {
        self.backgroundColor = backgroundColor
        self.headerLabel = headerLabel
        self.doneButton = doneButton
        self.cancelButton = cancelButton
    }
}
