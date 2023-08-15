//
//  Constants.swift
//  Frames
//
//  Copyright © 2022 Checkout. All rights reserved.
//

enum Constants {

    static let productName = "frames-ios-sdk"
    static let version = "4.2.0"
    static let userAgent = "checkout-sdk-frames-ios/\(version)"

    enum Logging {
        enum BarStyle: String {
            case `default`
            case black
            case blackTranslucent
            case unknown
        }
    }

    enum Bundle: String {
        case version = "CFBundleShortVersionString"

        enum FallbackValues: String {
            case noBundleIdentifier = "unavailableAppPackageName"
            case noVersion = "unavailableAppPackageVersion"
        }
    }
}
