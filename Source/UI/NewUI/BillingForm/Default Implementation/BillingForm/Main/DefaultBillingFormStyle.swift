import UIKit

struct DefaultBillingFormStyle: BillingFormStyle {
    var mainBackground: UIColor
    var header: BillingFormHeaderCellStyle
    var cells: [BillingFormCell]

    init(mainBackground: UIColor = .white,
         header: BillingFormHeaderCellStyle = DefaultBillingFormHeaderCellStyle(),
         cells: [BillingFormCell] = BillingFormFactory.cellsStyleInOrder) {
        self.mainBackground = mainBackground
        self.header = header
        self.cells = cells
    }
}
