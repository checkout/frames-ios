//
//  UIFont+PropertyProvidingTests.swift
//  FramesTests
//
//  Created by Harry Brown on 25/03/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
@testable import Frames

final class UIFont_PropertyProvidingTests: XCTestCase {
    let font = UIFont(name: "Arial", size: 12)!

    func test_equality() {
        XCTAssertEqual(font.properties, font.properties)
    }

    func test_properties() {
        XCTAssertEqual(font.properties, [.size: 12.0, .name: "ArialMT"])
    }
}
