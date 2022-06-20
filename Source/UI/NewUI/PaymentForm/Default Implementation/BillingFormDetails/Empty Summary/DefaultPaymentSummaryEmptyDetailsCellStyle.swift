import UIKit

public struct DefaultPaymentSummaryEmptyDetailsCellStyle: CellButtonStyle {
    public var backgroundColor: UIColor = .clear
    public var button: ElementButtonStyle = DefaultPaymentSummaryEmptyDetailsButtonStyle()
    public var isMandatory: Bool = true
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: "billingAddressTitle".localized(forClass: CheckoutTheme.self))
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: "We need this information as an additional security measure to verify this card.")
    public var mandatory: ElementStyle?
    public var error: ElementErrorViewStyle?
}
