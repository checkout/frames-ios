import UIKit

public struct DefaultErrorInputLabelStyle: ElementErrorViewStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var isHidden = true
    public var backgroundColor: UIColor = .clear
    public var tintColor: UIColor = UIStyle.Color.textError
    public var text: String = ""
    public var font = UIStyle.Font.bodySmallPlus
    public var textColor: UIColor = UIStyle.Color.textError
    public var image: UIImage? = Constants.Bundle.Images.warning.image
    public var height: Double = Constants.Style.BillingForm.InputErrorLabel.height.rawValue
}
