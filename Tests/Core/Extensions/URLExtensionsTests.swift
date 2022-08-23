//
//  URL+ExtensionsTests.swift
//  Frames-Unit-Tests
//
//  Created by Harry.Brown on 17/09/2021.
//

import XCTest
@testable import Frames

final class URLExtensionsTests: XCTestCase {
    func test_withoutQuery_withQuery() throws {
        let testURL = try XCTUnwrap(URL(string: "https://www.checkout.com/test/path?test=test_value"))
        let expectedResult = try XCTUnwrap(URL(string: "https://www.checkout.com/test/path"))
        let actualResult = testURL.withoutQuery

        XCTAssertEqual(actualResult, expectedResult)
    }

    func test_withoutQuery_withoutQuery() throws {
        let testURL = try XCTUnwrap(URL(string: "https://www.checkout.com/test/path"))
        let expectedResult = try XCTUnwrap(URL(string: "https://www.checkout.com/test/path"))
        let actualResult = testURL.withoutQuery

        XCTAssertEqual(actualResult, expectedResult)
    }
}
