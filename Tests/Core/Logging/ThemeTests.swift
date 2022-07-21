//
//  ThemeTests.swift
//  FramesTests
//
//  Created by Harry Brown on 31/03/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
import CheckoutEventLoggerKit
@testable import Frames

final class ThemeTests: XCTestCase {
    let subject = Theme()
    let font = UIFont(name: "Arial", size: 12)!

    override func setUp() {
        CheckoutTheme.font = font
    }

    func test_equality() {
        XCTAssertEqual(subject, subject)
    }

    func test_properties() {
        let expected: [FramesLogEvent.Property: AnyCodable] = [.barStyle: AnyCodable("default"),
                                                               .tertiaryBackgroundColor: AnyCodable(["red": AnyCodable(Double(1)),
                                                                                                     "green": AnyCodable(Double(1)),
                                                                                                     "blue": AnyCodable(Double(1)),
                                                                                                     "alpha": AnyCodable(Double(1))]),
                                                               .primaryTextColor: AnyCodable(["red": AnyCodable(Double(0)),
                                                                                              "green": AnyCodable(Double(0)),
                                                                                              "blue": AnyCodable(Double(0)),
                                                                                              "alpha": AnyCodable(Double(1))]),
                                                               .secondaryTextColor: AnyCodable(["red": AnyCodable(Double(2.0 / 3.0)),
                                                                                                "alpha": AnyCodable(Double(1)),
                                                                                                "blue": AnyCodable(Double(2.0 / 3.0)),
                                                                                                "green": AnyCodable(Double(2.0 / 3.0))]),
                                                               .primaryBackgroundColor: AnyCodable(UIColor.groupTableViewBackground.properties.mapKeys(\.rawValue)),
                                                               .errorTextColor: AnyCodable(["blue": AnyCodable(Double(0)),
                                                                                            "red": AnyCodable(Double(1)),
                                                                                            "green": AnyCodable(Double(0)),
                                                                                            "alpha": AnyCodable(Double(1))]),
                                                               .font: AnyCodable(["size": AnyCodable(Double(12)),
                                                                                  "name": AnyCodable("ArialMT")]),
                                                               .secondaryBackgroundColor: AnyCodable(["alpha": AnyCodable(Double(1)),
                                                                                                      "red": AnyCodable(Double(1)),
                                                                                                      "green": AnyCodable(Double(1)),
                                                                                                      "blue": AnyCodable(Double(1))]),
                                                               .chevronColor: AnyCodable(["alpha": AnyCodable(Double(1)),
                                                                                          "blue": AnyCodable(Double(0)),
                                                                                          "red": AnyCodable(Double(0)),
                                                                                          "green": AnyCodable(Double(0))])]
        XCTAssertEqual(subject.properties, expected)
    }
}
