//
//  FrameUITests.swift
//  iOS Example Frame
//
//  Created by Alex Ioja-Yang on 22/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest

final class FrameUITests: XCTestCase {

    func testPaymentWithMinimumInput() {

        let app = XCUIApplication()
        app.launch()

        app.tapButton(name: "UITestDefault")
    }

}
