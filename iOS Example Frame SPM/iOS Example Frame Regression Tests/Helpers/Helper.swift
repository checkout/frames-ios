//
//  Helper.swift
//  iOS Example Frame Regression Tests
//
//  Created by Okhan Okbay on 10/08/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import XCTest

enum Helper {
    static func wait() {
        let _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.2)
    }
}

let snapshotPrecision: Float = 99.9
