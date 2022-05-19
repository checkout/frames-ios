import UIKit

struct DefaultBillingFormHeaderCellStyle: BillingFormHeaderCellStyle {
    
    var backgroundColor: UIColor = .white
    var headerLabel: CKOElementStyle = DefaultHeaderLabelFormStyle()
    var cancelButton: CKOElementButtonStyle = DefaultCancelButtonFormStyle()
    var doneButton: CKOElementButtonStyle = DefaultDoneFormButtonStyle()
}
