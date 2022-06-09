import UIKit

public struct DefaultCancelButtonFormStyle: ElementButtonStyle {
    public var image: UIImage?
    public var text: String = Constants.LocalizationKeys.BillingForm.Header.cancel
    public var font: UIFont =  UIFont.systemFont(ofSize: Constants.Style.BillingForm.CancelButton.fontSize.rawValue)
    public var activeTitleColor: UIColor = .brandeisBlue
    public var disabledTitleColor: UIColor = .doveGray
    public var disabledTintColor: UIColor = .doveGray
    public var activeTintColor: UIColor = .brandeisBlue
    public var backgroundColor: UIColor = .clear
    public var textColor: UIColor = .clear
    public var normalBorderColor: UIColor = .clear
    public var focusBorderColor: UIColor = .clear
    public var errorBorderColor: UIColor = .clear
    public var isHidden: Bool = false
    public var isEnabled: Bool = true
    public var height: Double = Constants.Style.BillingForm.CancelButton.height.rawValue
    public var width: Double = Constants.Style.BillingForm.CancelButton.width.rawValue
}
