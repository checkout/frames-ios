enum Constants {

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

extension Constants {
    enum Style {
        enum BillingForm {
            enum CancelButton: Double {
                case height = 44
                case width = 53
                case fontSize = 17
            }

            enum DoneButton: Double {
                case height = 44
                case width = 53
                case fontSize = 17
            }

            enum HeaderTitle: Double {
                case fontSize = 24
            }

            enum InputErrorLabel: Double {
                case height = 18
            }

            enum InputHintLabel: Double {
                case fontSize = 13
            }

            enum InputTextField: Double {
                case height = 56
                case width = 335.0
                case fontSize = 16
            }

            enum InputTitleLabel: Double {
                case fontSize = 15
            }
        }
    }
}
