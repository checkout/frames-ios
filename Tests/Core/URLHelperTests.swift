//
//  URLHelperTests.swift
//  Frames
//
//  Created by Harry.Brown on 21/09/2021.
//

import XCTest
@testable import Frames

class URLHelperTests: XCTestCase {

    let subject = URLHelper()

    func test_extractToken() {

        let testCases = ["https://www.example.com/test": nil,
                         "https://www.example.com/test?cko-payment-token=": "",
                         "https://www.example.com/test?cko-payment-token=testValue": "testValue",
                         "https://www.example.com/test?cko-session-id=testValue": "testValue",
                         "https://www.example.com/test?cko-payment-token=testValue&cko-session-id=wrongValue": "testValue"]

        testCases.forEach { urlString, expectedToken in
            guard let url = URL(string: urlString) else {
                XCTFail("invalid URL: \(urlString)")
                return
            }

            XCTAssertEqual(subject.extractToken(from: url), expectedToken)
        }
    }

    func test_urlMatches() {

        let testCases = [("test://www.example.com/test?q=Success#hash", "https://www.example.com/test?q=Success#hash", false),
                         ("https://www.test.com/test?q=Success#hash", "https://www.example.com/test?q=Success#hash", false),
                         ("https://www.example.com?q=Success#hash", "https://www.example.com/test?q=Success#hash", false),
                         ("https://www.example.com/test?#hash", "https://www.example.com/test?q=Success#hash", false),
                         ("https://www.example.com/test?q=Success", "https://www.example.com/test?q=Success#hash", false),
                         ("https://www.example.com/test?q=Success#hash", "https://www.example.com/test?q=Success#hash", true),
                         ("https://www.example.com/test?q=Success&cko-session-id=wrongValue", "https://www.example.com/test?q=Success", true),
                         ("https://www.example.com/test?q=Success&hello=world", "https://www.example.com/test?hello=world&q=Success", true)]

        testCases.forEach { redirectURLString, matchingURLString, expectedResult in

            guard let redirectURL = URL(string: redirectURLString), let matchingURL = URL(string: matchingURLString) else {
                XCTFail("invalid URLs: \(redirectURLString) | \(matchingURLString)")
                return
            }

            XCTAssertEqual(subject.urlsMatch(redirectUrl: redirectURL, matchingUrl: matchingURL), expectedResult, "redirectURL: \(redirectURLString), matchingURL: \(matchingURLString)")
        }
    }
}
