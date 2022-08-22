import UIKit

public struct DefaultAddBillingDetailsViewStyle: CellButtonStyle {
    public var mandatory: ElementStyle?
    public var backgroundColor: UIColor = .clear
    public var button: ElementButtonStyle = DefaultAddBillingDetailsButtonStyle()
    public var isMandatory = true
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: LocalizationKey.billingAddress.localizedValue)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: LocalizationKey.billingAddressSummaryHint.localizedValue)
    public var error: ElementErrorViewStyle?
}
