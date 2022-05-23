import UIKit

struct DefaultHeaderLabelFormStyle: ElementStyle {
    var backgroundColor: UIColor = .clear
    var isHidden: Bool = false
    var text: String = Constants.LocalizationKeys.BillingForm.Header.title
    var font: UIFont = UIFont(graphikStyle: .medium, size: Constants.Style.BillingForm.HeaderTitle.fontSize.rawValue)
    var textColor: UIColor  = .codGray
}
