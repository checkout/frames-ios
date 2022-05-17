import UIKit

public protocol CKOTextFieldStyle {
    var text: String { get set }
    var placeHolder: String { get }
    var isPlaceHolderHidden: Bool { get }
    var font: UIFont { get }
    var textColor: UIColor { get }
    var normalBorderColor: UIColor { get }
    var focusBorderColor: UIColor { get }
    var errorBorderColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var tintColor: UIColor { get }
    var width: Double { get }
    var height: Double { get }
    var isSecured: Bool { get }
    var isSupprtingNumbericKeyboard: Bool { get }
}
