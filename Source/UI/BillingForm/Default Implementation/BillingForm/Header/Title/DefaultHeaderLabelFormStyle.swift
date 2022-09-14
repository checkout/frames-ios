import UIKit

public struct DefaultHeaderLabelFormStyle: ElementStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var backgroundColor: UIColor = .clear
    public var isHidden = false
    public var text: String = ""
    public var font = CKOUIStyle.Font.Title.title2
    public var textColor: UIColor = CKOUIStyle.Color.Text.primary
}
