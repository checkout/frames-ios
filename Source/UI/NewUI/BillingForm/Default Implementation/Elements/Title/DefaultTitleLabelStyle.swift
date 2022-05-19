import UIKit

struct DefaultTitleLabelStyle: CKOElementStyle {
    var backgroundColor: UIColor = .clear
    var isHidden: Bool = false
    var text: String = ""
    var font: UIFont = UIFont(graphikStyle: .regular, size: Constants.Style.BillingForm.InputTitleLabel.fontSize.rawValue)
    var textColor: UIColor = .codGray
}
