import UIKit

struct DefaultErrorInputLabelStyle: ElementErrorViewStyle {
    var isHidden: Bool = true
    var isWarningImageOnLeft: Bool = true
    var backgroundColor: UIColor = .white
    var tintColor: UIColor = .tallPoppyRed
    var text: String = ""
    var font: UIFont = UIFont(graphikStyle: .medium, size: Constants.Style.BillingForm.InputErrorLabel.fontSize.rawValue)
    var textColor: UIColor =  .tallPoppyRed
    var image: UIImage =  "warning".vectorPDFImage(forClass: CheckoutTheme.self) ?? UIImage()
    var height: Double = Constants.Style.BillingForm.InputErrorLabel.height.rawValue
}
