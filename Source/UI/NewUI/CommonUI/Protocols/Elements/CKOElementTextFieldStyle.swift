import UIKit

public protocol CKOElementTextFieldStyle: CKOElementStyle {
    var placeHolder: String { get }
    var tintColor: UIColor { get }
    var isPlaceHolderHidden: Bool { get }
    var normalBorderColor: UIColor { get }
    var focusBorderColor: UIColor { get }
    var errorBorderColor: UIColor { get }
    var isSecured: Bool { get }
    var isSupprtingNumbericKeyboard: Bool { get }
    var height: Double { get }
}
