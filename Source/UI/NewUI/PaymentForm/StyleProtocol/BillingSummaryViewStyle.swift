import UIKit

public protocol BillingSummaryViewStyle: CellButtonStyle {
    var summary: ElementStyle? { get set }
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    var separatorLineColor: UIColor { get set }
    var borderColor: UIColor { get set }
}
