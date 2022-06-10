//
//  UIColor+PropertyProvidingTests.swift
//  FramesTests
//
//  Created by Harry Brown on 24/03/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
@testable import Frames
import CheckoutEventLoggerKit

final class UIColor_PropertyProvidingTests: XCTestCase {

    func test_equality() {
        XCTAssertEqual(UIColor.black.properties, UIColor.black.properties)
    }

    func test_properties() {
        XCTAssertEqual(UIColor.systemBlue.properties, [.alpha: 1.0,
                                                       .blue: 1.0,
                                                       .red: 0.0,
                                                       .green: AnyCodable(122.0 / 255.0)])
    }
}
