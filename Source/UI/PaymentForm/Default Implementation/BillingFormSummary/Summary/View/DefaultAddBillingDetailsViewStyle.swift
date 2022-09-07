import UIKit

public struct DefaultAddBillingDetailsViewStyle: CellButtonStyle {
    public var mandatory: ElementStyle?
    public var backgroundColor: UIColor = .clear
    public var button: ElementButtonStyle = DefaultAddBillingDetailsButtonStyle()
    public var isMandatory = true
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.Header.title)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: Constants.LocalizationKeys.PaymentForm.BillingSummary.hint)
    public var error: ElementErrorViewStyle?
}
