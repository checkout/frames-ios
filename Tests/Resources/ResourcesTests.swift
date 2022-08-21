//
//  ResourcesTests.swift
//  Frames-Unit-Tests
//
//  Created by Harry Brown on 12/10/2021.
//

import XCTest
@testable import Frames

final class ResourcesTests: XCTestCase {
    func test_findExpectedResources() {
        let framesTopLevelBundle = Bundle(for: CardUtils.self)

        #if SWIFT_PACKAGE
        let framesResourceBundlePath = "Frames_Frames"
        guard let framesResourceBundleURL = framesTopLevelBundle.url(forResource: framesResourceBundlePath, withExtension: "bundle") else {
            XCTFail("could not find resource bundle url")
            return
        }
        #endif

        #if COCOAPODS
        let framesResourceBundlePath = "Frames"
        guard let framesResourceBundleURL = framesTopLevelBundle.url(forResource: framesResourceBundlePath, withExtension: "bundle") else {
            XCTFail("could not find resource bundle url")
            return
        }
        #endif

        #if !SWIFT_PACKAGE && !COCOAPODS
        let framesResourceBundleURL = framesTopLevelBundle.bundleURL
        #endif

        guard let framesResourceBundle = Bundle(url: framesResourceBundleURL) else {
            XCTFail("could not find internal bundle")
            return
        }

        XCTAssertEqual(framesResourceBundle.localizations.count, 6)
        XCTAssertNotNil(UIImage(named: "icon-amex", in: framesResourceBundle, compatibleWith: nil))
    }
}
