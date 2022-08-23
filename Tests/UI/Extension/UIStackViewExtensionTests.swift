//
//  UIStackViewExtensionTests.swift
//  iOS Example FrameUITests
//
//  Created by Ehab Alsharkawy on 06/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
@testable import Frames

class UIStackViewExtensionTests: XCTestCase {
    func testAddArrangedSubviews() {
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()
        let stackView = UIStackView()

        stackView.addArrangedSubviews([view1, view2, view3])

        XCTAssertEqual(stackView.arrangedSubviews[0], view1)
        XCTAssertEqual(stackView.arrangedSubviews[1], view2)
        XCTAssertEqual(stackView.arrangedSubviews[2], view3)
    }
}
