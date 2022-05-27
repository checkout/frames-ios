import UIKit

class DefaultCountryFormButtonStyle: ElementButtonStyle {
    var image: UIImage? = "arrow_blue_right".vectorPDFImage(forClass: CheckoutTheme.self)
    var text: String = "countryRegion".localized(forClass: CheckoutTheme.self)
    var font: UIFont = UIFont(graphikStyle: .regular, size: Constants.Style.BillingForm.InputCountryButton.fontSize.rawValue)
    var activeTitleColor: UIColor = .brandeisBlue
    var disabledTitleColor: UIColor = .mediumGray
    var disabledTintColor: UIColor = .mediumGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .clear
    var normalBorderColor: UIColor = .mediumGray
    var focusBorderColor: UIColor = .brandeisBlue
    var errorBorderColor: UIColor = .tallPoppyRed
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = Constants.Style.BillingForm.InputCountryButton.height.rawValue
    var width: Double = Constants.Style.BillingForm.InputCountryButton.width.rawValue
}
