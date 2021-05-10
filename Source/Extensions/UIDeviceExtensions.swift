import UIKit

protocol UIDevice {

    var modelName: String { get }
    var systemVersion: String { get }
}

extension UIKit.UIDevice: UIDevice {

    var modelName: String {
        // added simulator support from https://gist.github.com/SergLam/50c0e400877d76c499c2649b109b3890
        #if targetEnvironment(simulator)
        if let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return identifier
        }
        #endif

        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
}
