import UIKit

public struct DefaultBillingFormCountryCellStyle: CellButtonStyle {
    public var backgroundColor: UIColor = .clear
    public var button: ElementButtonStyle = DefaultCountryFormButtonStyle()
    public var isMandatory = true
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.Country.text)
    public var hint: ElementStyle?
    public var mandatory: ElementStyle?
    public var error: ElementErrorViewStyle?
}
