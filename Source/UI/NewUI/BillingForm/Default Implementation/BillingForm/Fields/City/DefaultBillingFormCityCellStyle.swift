import UIKit

struct DefaultBillingFormCityCellStyle: CellTextFieldStyle {
    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: "city".localized(forClass: CheckoutTheme.self))
    var hint: ElementStyle?
    var textfield: ElementTextFieldStyle = DefaultTextField()
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCity".localized(forClass: CheckoutTheme.self))

}
