import UIKit

struct DefaultBillingFormHeaderCellStyle: BillingFormHeaderCellStyle {

    var backgroundColor: UIColor = .white
    var headerLabel: ElementStyle = DefaultHeaderLabelFormStyle()
    var cancelButton: ElementButtonStyle = DefaultCancelButtonFormStyle()
    var doneButton: ElementButtonStyle = DefaultDoneFormButtonStyle()
}
