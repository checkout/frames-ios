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

        #if SWIFT_PACKAGE
        let framesResourceBundlePath = "Frames_Frames"
        #endif
        
        #if COCOAPODS
        let framesResourceBundlePath = "Frames"
        #endif
        
        let framesTopLevelBundle = Bundle(for: CheckoutAPIClient.self)
        guard let framesResourceBundleURL = framesTopLevelBundle.url(forResource: framesResourceBundlePath, withExtension: "bundle") else {
            XCTFail("could not find resource bundle url")
            return
        }

        guard let framesResourceBundle = Bundle(url: framesResourceBundleURL) else {
            XCTFail("could not find internal bundle")
            return
        }
        
        XCTAssertEqual(framesResourceBundle.localizations.count, 6)
        XCTAssertNotNil(framesResourceBundle.url(forResource: "icon-amex", withExtension: "png"))
    }
}

