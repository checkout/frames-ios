import UIKit

struct DefaultCancelButtonFormStyle: CKOElementButtonStyle {

    var text: String = "cancel".localized(forClass: CheckoutTheme.self)
    var font: UIFont =  UIFont.systemFont(ofSize: Constants.Style.BillingForm.CancelButton.fontSize.rawValue)
    var activeTitleColor: UIColor = .brandeisBlue
    var disabledTitleColor: UIColor = .doveGray
    var disabledTintColor: UIColor = .doveGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .clear
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = Constants.Style.BillingForm.CancelButton.height.rawValue
    var width: Double = Constants.Style.BillingForm.CancelButton.width.rawValue
}
