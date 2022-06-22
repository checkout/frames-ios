import UIKit

public protocol CellButtonStyle: CellStyle {
    var button: ElementButtonStyle { get set }
}

public protocol SummaryCellButtonStyle: CellStyle {
    var button: ElementButtonStyle { get set }
    var summary: ElementStyle { get set }
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    var separatorLineColor: UIColor { get set }
    var borderColor: UIColor { get set }
}
