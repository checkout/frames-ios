import UIKit

public struct DefaultBillingFormCountryCellStyle: CellButtonStyle {
    public var backgroundColor: UIColor = .clear
    public var button: ElementButtonStyle = DefaultCountryFormButtonStyle()
    public var isMandatory: Bool = true
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.Country.text, textColor: .doveGray)
    public var hint: ElementStyle? = nil
    public var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.Country.error)
}
