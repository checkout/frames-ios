//
//  UIStackViewExtensionTests.swift
//  FramesTests
//
//  Created by Ehab Alsharkawy on 08/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
@testable import Frames

class UIViewExtensionTests: XCTestCase {
  func testRemoveArrangedSubviews() {
    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
    let stackView = UIStackView(arrangedSubviews: [view1, view2, view3])
    stackView.removeSubviews()

    XCTAssertEqual(stackView.arrangedSubviews.count, 0)
  }
}
