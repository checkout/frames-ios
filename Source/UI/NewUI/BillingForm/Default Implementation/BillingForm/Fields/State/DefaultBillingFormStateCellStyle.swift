import UIKit

struct DefaultBillingFormStateCellStyle: CellTextFieldStyle {

    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: "countryRegion".localized(forClass: CheckoutTheme.self))
    var hint: ElementStyle?
    var textfield: ElementTextFieldStyle = DefaultTextField()
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormState".localized(forClass: CheckoutTheme.self))

}
