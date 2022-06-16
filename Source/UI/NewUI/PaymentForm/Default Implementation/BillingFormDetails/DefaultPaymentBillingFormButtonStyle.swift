import UIKit

public class DefaultPaymentBillingFormButtonStyle: ElementButtonStyle {
    public var image: UIImage? = "arrow_blue_right".vectorPDFImage(forClass: CheckoutTheme.self)
    public var text: String = "Add billing address".localized(forClass: CheckoutTheme.self)
    public var font: UIFont = UIFont(graphikStyle: .regular, size: Constants.Style.BillingForm.InputCountryButton.fontSize.rawValue)
    public var activeTitleColor: UIColor = .brandeisBlue
    public var disabledTitleColor: UIColor = .mediumGray
    public var disabledTintColor: UIColor = .mediumGray
    public var activeTintColor: UIColor = .brandeisBlue
    public var backgroundColor: UIColor = .clear
    public var textColor: UIColor = .clear
    public var normalBorderColor: UIColor = .mediumGray
    public var focusBorderColor: UIColor = .brandeisBlue
    public var errorBorderColor: UIColor = .tallPoppyRed
    public var isHidden: Bool = false
    public var isEnabled: Bool = true
    public var height: Double = Constants.Style.PaymentForm.InputBillingFormButton.height.rawValue
    public var width: Double = Constants.Style.PaymentForm.InputBillingFormButton.width.rawValue
    public var cornerRadius: CGFloat = Constants.Style.PaymentForm.InputBillingFormButton.cornerRadius.rawValue
    public var borderWidth: CGFloat = Constants.Style.PaymentForm.InputBillingFormButton.borderWidth.rawValue
}
