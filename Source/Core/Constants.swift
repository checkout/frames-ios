@frozen enum Constants {

    static let productName = "frames-ios-sdk"
    static let version = "3.5.3"
    static let userAgent = "checkout-sdk-frames-ios/\(version)"

<<<<<<< HEAD
    struct Logging {
        enum BarStyle: String {
            case `default`
            case black
            case blackTranslucent
            case unknown
=======
    enum Bundle {
        enum SchemeIcons: String {
            case amex = "schemes/icon-amex"
            case diners = "schemes/icon-dinersclub"
            case discover = "schemes/icon-discover"
            case jcb = "schemes/icon-jcb"
            case maestro = "schemes/icon-maestro"
            case mastercard = "schemes/icon-mastercard"
            case visa = "schemes/icon-visa"
>>>>>>> release/4.0.0_RC
        }
    }
}
