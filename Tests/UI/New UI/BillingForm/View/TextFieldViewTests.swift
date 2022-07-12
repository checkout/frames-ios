//
//  TextFieldViewTests.swift
//  FramesTests
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
@testable import Frames

class TextFieldViewTests: XCTestCase {
  var view: TextFieldView!
  var style: ElementTextFieldStyle!

  override func setUp() {
    super.setUp()
    UIFont.loadAllCheckoutFonts
    style = DefaultTextField()
    view = TextFieldView()
    view.update(with: style)
  }

  func testSecuredTextFieldViewIsNotSubView() {
    let subviews = view.subviews

    let isTextFieldExposed = subviews.contains {
      $0 is UITextField
    }
    XCTAssertFalse(isTextFieldExposed)
  }

  func testSecuredTextFieldMirror() {
    let mirror = Mirror(reflecting: view as Any)

    mirror.children.forEach {
      XCTAssertFalse($0.value is UITextField)
    }
  }

  func testSecuredTextFieldWithMirrorObject() {
    let viewMirror = TextFieldViewToTestMirror(view: view)
    XCTAssertNil(viewMirror.textField)
  }

}

private final class TextFieldViewToTestMirror: MirrorObject {
  var textField: UITextField? { extract() }

  init(view: TextFieldView) {
    super.init(reflecting: view)
  }
}