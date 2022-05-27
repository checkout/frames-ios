import UIKit

struct DefaultDoneFormButtonStyle: ElementButtonStyle {
    var image: UIImage? = nil
    var text: String = Constants.LocalizationKeys.BillingForm.Header.done
    var font: UIFont = UIFont.systemFont(ofSize: Constants.Style.BillingForm.DoneButton.fontSize.rawValue)
    var activeTitleColor: UIColor = .brandeisBlue
    var disabledTitleColor: UIColor = .doveGray
    var disabledTintColor: UIColor = .doveGray
    var activeTintColor: UIColor = .brandeisBlue
    var backgroundColor: UIColor = .white
    var normalBorderColor: UIColor = .clear
    var focusBorderColor: UIColor = .clear
    var errorBorderColor: UIColor = .clear
    var textColor: UIColor = .clear
    var isHidden: Bool = false
    var isEnabled: Bool = true
    var height: Double = Constants.Style.BillingForm.DoneButton.height.rawValue
    var width: Double = Constants.Style.BillingForm.DoneButton.width.rawValue
}
