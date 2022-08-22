import UIKit

public struct DefaultBillingSummaryViewStyle: BillingSummaryViewStyle {
    public var isMandatory = true
    public var cornerRadius: CGFloat = 10
    public var borderWidth: CGFloat = 1.0
    public var separatorLineColor: UIColor = .paleGray
    public var backgroundColor: UIColor = .clear
    public var borderColor: UIColor = .doveGray
    public var button: ElementButtonStyle = DefaultEditBillingDetailsButtonStyle()
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: LocalizationKey.billingAddress.localizedValue)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: LocalizationKey.billingAddressSummaryHint.localizedValue)
    public var summary: ElementStyle? = DefaultTitleLabelStyle()
    public var mandatory: ElementStyle?
    public var error: ElementErrorViewStyle?
}
