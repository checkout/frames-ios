import UIKit

public struct DefaultErrorInputLabelStyle: ElementErrorViewStyle {
    public var isHidden: Bool = true
    public var isWarningImageOnLeft: Bool = true
    public var shouldImageFlippedForRightToLeftLayoutDirection: Bool = false
    public var backgroundColor: UIColor = .clear
    public var tintColor: UIColor = .tallPoppyRed
    public var text: String = ""
    public var font: UIFont = UIFont(graphikStyle: .medium, size: Constants.Style.BillingForm.InputErrorLabel.fontSize.rawValue)
    public var textColor: UIColor =  .tallPoppyRed
    public var image: UIImage =  "warning".vectorPDFImage(forClass: CheckoutTheme.self) ?? UIImage()
    public var height: Double = Constants.Style.BillingForm.InputErrorLabel.height.rawValue
}
