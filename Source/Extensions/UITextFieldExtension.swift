import UIKit

extension UITextField {
    // Disable hardware keyboards.
    static func disableHardwareLayout() {
#if targetEnvironment(simulator)
// swiftlint:disable indentation_width
        let setHardwareLayout = NSSelectorFromString("setHardwareLayout:")

        UITextInputMode.activeInputModes
            .filter { $0.responds(to: setHardwareLayout) }
            .forEach { $0.perform(setHardwareLayout, with: nil) }
// swiftlint:enable indentation_width
#endif
    }
}
