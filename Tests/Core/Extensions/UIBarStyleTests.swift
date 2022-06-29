//
//  UIBarStyleTests.swift
//  FramesTests
//
//  Created by Harry Brown on 31/03/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
@testable import Frames

final class UIBarStyleTests: XCTestCase {

    func test_stringValue() {
        let testCases: [(UIBarStyle, String)] = [(.default, "default"),
                                                 (.black, "black"),
                                                 (.blackOpaque, "black"),
                                                 (.blackTranslucent, "blackTranslucent")]

        testCases.forEach { subject, expectedValue in
            XCTAssertEqual(subject.stringValue, expectedValue, "expected \(expectedValue), received \(subject.stringValue) for \(subject)")
        }
    }
}
