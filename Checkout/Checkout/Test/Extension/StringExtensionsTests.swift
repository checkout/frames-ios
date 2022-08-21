//
//  StringExtensionsTests.swift
//  
//
//  Created by Alex Ioja-Yang on 12/08/2022.
//

@testable import Checkout
import XCTest

final class StringExtensionsTests: XCTestCase {
    func testRemoveWhitespaces() {
        XCTAssertEqual("1234567789".removeWhitespaces(), "1234567789")
        XCTAssertEqual("ABCDEDFG2344gdsfg".removeWhitespaces(), "ABCDEDFG2344gdsfg")
        XCTAssertEqual("          ".removeWhitespaces(), "")
        XCTAssertEqual("ABC DEDF G2344   gdsfg123 -456 7789".removeWhitespaces(), "ABCDEDFG2344gdsfg123-4567789")
    }
}
