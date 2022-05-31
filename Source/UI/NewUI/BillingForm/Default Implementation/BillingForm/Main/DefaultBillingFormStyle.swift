import UIKit

public struct DefaultBillingFormStyle: BillingFormStyle {
    public var mainBackground: UIColor = .white
    public var header: BillingFormHeaderCellStyle = DefaultBillingFormHeaderCellStyle()
    public var cells: [BillingFormCell] = BillingFormFactory.cellsStyleInOrder
}
