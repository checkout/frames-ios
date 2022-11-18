import UIKit

public protocol ElementTextFieldStyle: ElementStyle {
    var isSupportingNumericKeyboard: Bool { get set }
    var height: Double { get }
    var placeholder: String? { get }
    var tintColor: UIColor { get }
    var borderStyle: ElementBorderStyle { get }
}
