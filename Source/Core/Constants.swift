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

        enum SchemeIcon: String {
            case blank = "icon-blank"
            case americanExpress = "icon-amex"
            case dinersClub = "icon-diners"
            case discover = "icon-discover"
            case jcb = "icon-jcb"
            case maestro = "icon-maestro"
            case mastercard = "icon-mastercard"
            case mada = "icon-mada"
            case visa = "icon-visa"
        }

        enum FallbackValues: String {
            case noBundleIdentifier = "unavailableAppPackageName"
            case noVersion = "unavailableAppPackageVersion"
        }
    }
}
