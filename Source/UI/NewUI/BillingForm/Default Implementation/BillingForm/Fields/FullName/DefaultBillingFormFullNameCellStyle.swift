import UIKit

struct DefaultBillingFormFullNameCellStyle: CellTextFieldStyle {

    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: "name".localized(forClass: CheckoutTheme.self))
    var hint: ElementStyle?
    var textfield: ElementTextFieldStyle = DefaultTextField()
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormFullName".localized(forClass: CheckoutTheme.self))
}
