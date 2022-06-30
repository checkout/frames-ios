//
//  Constants.swift
//  Frames
//
//  Copyright © 2022 Checkout. All rights reserved.
//

enum Constants {

    static let productName = "frames-ios-sdk"
    static let version = "3.5.3"
    static let userAgent = "checkout-sdk-frames-ios/\(version)"

    struct Logging {
        enum BarStyle: String {
            case `default`
            case black
            case blackTranslucent
            case unknown
        }
    }

    enum Bundle: String {
        case version = "CFBundleShortVersionString"

        enum SchemeIcons: String {
            case americanExpress = "schemes/icon-amex"
            case dinersClub = "schemes/icon-dinersclub"
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
