import UIKit

public struct DefaultBillingFormHeaderCellStyle: BillingFormHeaderCellStyle {
    public var backgroundColor: UIColor = .clear
    public var headerLabel: ElementStyle = DefaultHeaderLabelFormStyle(text: Constants.LocalizationKeys.BillingForm.Header.title)
    public var cancelButton: ElementButtonStyle = DefaultCancelButtonFormStyle()
    public var doneButton: ElementButtonStyle = DefaultDoneFormButtonStyle()
}
