import UIKit

public struct DefaultBillingFormStyle: BillingFormStyle {
    public var mainBackground: UIColor = FramesUIStyle.Color.backgroundPrimary
    public var header: BillingFormHeaderCellStyle = DefaultBillingFormHeaderCellStyle()
    public var cells: [BillingFormCell] = FramesFactory.cellsStyleInOrder

    public init() {}
}
