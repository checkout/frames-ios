import UIKit

public class DefaultPaymentSummaryEmptyDetailsButtonStyle: ElementButtonStyle {
    public var image: UIImage? = "arrow_blue_right".vectorPDFImage(forClass: CheckoutTheme.self)
    public var text: String = "AddBillingAddress".localized(forClass: CheckoutTheme.self)
    public var font: UIFont = UIFont(graphikStyle: .regular, size: Constants.Style.BillingForm.InputCountryButton.fontSize.rawValue)
    public var textColor: UIColor = .brandeisBlue
    public var disabledTextColor: UIColor = .mediumGray
    public var disabledTintColor: UIColor = .mediumGray
    public var activeTintColor: UIColor = .brandeisBlue
    public var backgroundColor: UIColor = .clear
    public var normalBorderColor: UIColor = .brandeisBlue
    public var focusBorderColor: UIColor = .mediumGray
    public var errorBorderColor: UIColor = .tallPoppyRed
    public var imageTintColor: UIColor = .brandeisBlue
    public var isHidden: Bool = false
    public var isEnabled: Bool = true
    public var height: Double = Constants.Style.PaymentForm.InputBillingFormButton.height.rawValue
    public var width: Double = Constants.Style.PaymentForm.InputBillingFormButton.width.rawValue
    public var cornerRadius: CGFloat = Constants.Style.PaymentForm.InputBillingFormButton.cornerRadius.rawValue
    public var borderWidth: CGFloat = Constants.Style.PaymentForm.InputBillingFormButton.borderWidth.rawValue
    public var textLeading: CGFloat = Constants.Style.PaymentForm.InputBillingFormButton.textLeading.rawValue
}
