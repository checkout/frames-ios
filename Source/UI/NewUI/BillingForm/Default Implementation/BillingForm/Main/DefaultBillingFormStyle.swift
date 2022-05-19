import UIKit

struct DefaultBillingFormStyle: BillingFormStyle {
    var mainBackground: UIColor = .white
    var header: BillingFormHeaderCellStyle = DefaultBillingFormHeaderCellStyle()
    var cells: [BillingFormCell] = BillingFormFactory.cellsStyleInOrder
}
