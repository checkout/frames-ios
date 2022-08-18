import UIKit

public struct DefaultAddBillingDetailsViewStyle: CellButtonStyle {
    public var mandatory: ElementStyle?
    public var backgroundColor: UIColor = .clear
    public var button: ElementButtonStyle = DefaultAddBillingDetailsButtonStyle()
    public var isMandatory: Bool = true
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: "billingAddressTitle".localized(forClass: CheckoutTheme.self))
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: "PaymentFormSummaryViewHintText".localized(forClass: CheckoutTheme.self))
    public var error: ElementErrorViewStyle?
}
