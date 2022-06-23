import UIKit

public struct DefaultBillingSummaryViewStyle: BillingSummaryViewStyle {
    public var isMandatory: Bool = true
    public var cornerRadius: CGFloat = 10
    public var borderWidth: CGFloat = 1.0
    public var separatorLineColor: UIColor = .doveGray
    public var backgroundColor: UIColor = .clear
    public var borderColor: UIColor = .doveGray
    public var button: ElementButtonStyle = DefaultEditBillingDetailsButtonStyle()
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: "billingAddressTitle".localized(forClass: CheckoutTheme.self))
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: "We need this information as an additional security measure to verify this card.")
    public var summary: ElementStyle? = DefaultTitleLabelStyle()
    public var mandatory: ElementStyle?
    public var error: ElementErrorViewStyle?
}
