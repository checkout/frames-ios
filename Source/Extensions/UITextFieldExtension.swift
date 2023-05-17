import UIKit

extension UITextField {

    /// String generated after the range and the modification proposed are applied to current text
    func newTextAfter(applyingString newString: String, at range: NSRange) -> String? {
        if let text = text,
           let textRange = Range(range, in: text) {
            return text.replacingCharacters(in: textRange, with: newString)
        }
        return nil
    }

    static func disableHardwareLayout() {
#if targetEnvironment(simulator)
        // Disable hardware keyboards.
        let setHardwareLayout = NSSelectorFromString("setHardwareLayout:")

        // Filter `UIKeyboardInputMode`s.
        UITextInputMode.activeInputModes
            .filter { $0.responds(to: setHardwareLayout) }
            .forEach { $0.perform(setHardwareLayout, with: nil) }
#endif
    }
}
