import UIKit

extension UITextField {

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
