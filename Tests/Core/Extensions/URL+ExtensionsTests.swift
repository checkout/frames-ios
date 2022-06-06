//
//  URL+ExtensionsTests.swift
//  Frames-Unit-Tests
//
//  Created by Harry.Brown on 17/09/2021.
//

import XCTest
@testable import Frames

final class URL_ExtensionsTests: XCTestCase {

    func test_withoutQuery_withQuery() {
        let testURL = URL(string: "https://www.checkout.com/test/path?test=test_value")!
        let expectedResult = URL(string: "https://www.checkout.com/test/path")!
        let actualResult = testURL.withoutQuery

        XCTAssertEqual(actualResult, expectedResult)
    }

    func test_withoutQuery_withoutQuery() {
        let testURL = URL(string: "https://www.checkout.com/test/path")!
        let expectedResult = URL(string: "https://www.checkout.com/test/path")!
        let actualResult = testURL.withoutQuery

        XCTAssertEqual(actualResult, expectedResult)
    }
}
