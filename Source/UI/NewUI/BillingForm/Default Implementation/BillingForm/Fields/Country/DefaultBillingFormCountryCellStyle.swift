import UIKit

struct DefaultBillingFormCountryCellStyle: CellButtonStyle {
    var backgroundColor: UIColor = .clear
    var button: ElementButtonStyle = DefaultCountryFormButtonStyle()
    var isOptional: Bool = false
    var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.Country.text, textColor: .doveGray)
    var hint: ElementStyle? = nil
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.Country.error)
}
