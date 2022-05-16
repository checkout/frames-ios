@frozen enum Constants {

    static let productName = "frames-ios-sdk"
    static let version = "3.5.2"
    static let userAgent = "checkout-sdk-frames-ios/\(version)"

    enum Bundle: String {
        case version = "CFBundleShortVersionString"

        enum SchemeIcons: String {
            case amex = "schemes/icon-amex"
            case diners = "schemes/icon-dinersclub"
            case discover = "schemes/icon-discover"
            case jcb = "schemes/icon-jcb"
            case maestro = "schemes/icon-maestro"
            case mastercard = "schemes/icon-mastercard"
            case visa = "schemes/icon-visa"
        }

        enum FallbackValues: String {
            case noBundleIdentifier = "unavailableAppPackageName"
            case noVersion = "unavailableAppPackageVersion"
        }
    }
}
