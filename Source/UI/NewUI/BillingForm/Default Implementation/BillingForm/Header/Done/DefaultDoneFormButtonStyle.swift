import UIKit

struct DefaultDoneFormButtonStyle: CKOElementButtonStyle {

    var text: String = "done".localized(forClass: CheckoutTheme.self)
    var font: UIFont = UIFont.systemFont(ofSize: Constants.Style.BillingForm.DoneButton.fontSize.rawValue)
    var activeTitleColor: UIColor = .brandeisBlue
    var disabledTitleColor: UIColor = .doveGray
    var disabledTintColor: UIColor = .doveGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .clear
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = Constants.Style.BillingForm.DoneButton.height.rawValue
    var width: Double = Constants.Style.BillingForm.DoneButton.width.rawValue
}
