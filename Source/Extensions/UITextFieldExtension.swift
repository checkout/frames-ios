import UIKit

extension UITextField {

    /// Returns a new string in which the characters in a general range have been applied to the current text
    func replacingCharacters(in range: NSRange, with replacementString: String) -> String? {
        if let text = text,
           let textRange = Range(range, in: text) {
            return text.replacingCharacters(in: textRange, with: replacementString)
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
