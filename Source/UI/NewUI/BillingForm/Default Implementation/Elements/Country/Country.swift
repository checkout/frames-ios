import UIKit

public struct DefaultCountryFormButtonStyle: ElementButtonStyle {
  public var image: UIImage? = Constants.Bundle.Images.rightArrow.image?.imageFlippedForRightToLeftLayoutDirection()
    public var text: String = "countryRegion".localized(forClass: CheckoutTheme.self)
    public var font: UIFont = UIFont(graphikStyle: .regular, size: Constants.Style.BillingForm.InputCountryButton.fontSize.rawValue)
    public var disabledTextColor: UIColor = .mediumGray
    public var disabledTintColor: UIColor = .mediumGray
    public var activeTintColor: UIColor = .brandeisBlue
    public var backgroundColor: UIColor = .clear
    public var textColor: UIColor = .mediumGray
    public var normalBorderColor: UIColor = .mediumGray
    public var focusBorderColor: UIColor = .brandeisBlue
    public var errorBorderColor: UIColor = .tallPoppyRed
    public var imageTintColor: UIColor = .mediumGray
    public var isHidden = false
    public var isEnabled = true
    public var textLeading: CGFloat = Constants.Style.BillingForm.InputCountryButton.textLeading.rawValue
    public var height: Double = Constants.Style.BillingForm.InputCountryButton.height.rawValue
    public var width: Double = Constants.Style.BillingForm.InputCountryButton.width.rawValue
    public var cornerRadius: CGFloat = Constants.Style.BillingForm.InputCountryButton.cornerRadius.rawValue
    public var borderWidth: CGFloat = Constants.Style.BillingForm.InputCountryButton.borderWidth.rawValue
}
