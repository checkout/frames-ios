import UIKit

struct DefaultErrorInputLabelStyle: CKOElementErrorViewStyle {
    var isHidden: Bool = true
    var backgroundColor: UIColor = .white
    var tintColor: UIColor = .tallPoppyRed
    var text: String = ""
    var font: UIFont = UIFont(graphikStyle: .medium, size: 13)
    var textColor: UIColor =  .tallPoppyRed
    var isWarningImageOnLeft: Bool = true
    var height: Double = Constants.Style.BillingForm.InputErrorLabel.height.rawValue
}
