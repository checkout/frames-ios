import UIKit

public struct DefaultHintInputLabelStyle: ElementStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var backgroundColor: UIColor = .clear
    public var isHidden = false
    public var text: String = ""
    public var font = FramesUIStyle.Font.bodySmall
    public var textColor: UIColor = FramesUIStyle.Color.textSecondary
}
