import UIKit

struct DefaultHintInputLabelStyle: CKOElementStyle {
    var backgroundColor: UIColor = .clear
    var isHidden: Bool = false
    var text: String = ""
    var font: UIFont = UIFont(graphikStyle: .regular, size: Constants.Style.BillingForm.InputHintLabel.fontSize.rawValue)
    var textColor: UIColor = .doveGray
}
