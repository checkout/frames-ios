import UIKit

public struct DefaultErrorInputLabelStyle: ElementErrorViewStyle {
    public var isHidden: Bool = true
    public var backgroundColor: UIColor = .clear
    public var tintColor: UIColor = .tallPoppyRed
    public var text: String = ""
    public var font: UIFont = UIFont.systemFont(ofSize: Constants.Style.BillingForm.InputErrorLabel.fontSize.rawValue)
    public var textColor: UIColor =  .tallPoppyRed
    public var image: UIImage? = Constants.Bundle.Images.warning.image
    public var height: Double = Constants.Style.BillingForm.InputErrorLabel.height.rawValue
}
