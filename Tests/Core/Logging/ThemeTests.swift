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
                                                               .primaryBackgroundColor: AnyCodable(["red": AnyCodable(Double(242.0 / 255.0)),
                                                                                                    "alpha": AnyCodable(Double(1)),
                                                                                                    "green": AnyCodable(Double(242.0 / 255.0)),
                                                                                                    "blue": AnyCodable(Double(247.0 / 255.0))]),
                                                               .errorTextColor: AnyCodable(["blue": AnyCodable(Double(0)),
                                                                                            "red": AnyCodable(Double(1)),
                                                                                            "green": AnyCodable(Double(0)),
                                                                                            "alpha": AnyCodable(Double(1))]),
                                                               .font: AnyCodable(["size": AnyCodable(Double(14)),
                                                                                  "name": AnyCodable(".SFUI-Regular")]),
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
