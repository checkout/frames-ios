//
//  SecurityCodeViewTests.swift
//  
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
import Checkout
@testable import Frames

class SecurityCodeViewTests: XCTestCase {
    var view: SecurityCodeView!
    var style: DefaultSecurityCodeFormStyle!

    override func setUp() {
        super.setUp()
        style = DefaultSecurityCodeFormStyle()
        let testCardValidator = CardValidator(environment: .sandbox)
        let testViewModel = SecurityCodeViewModel(cardValidator: testCardValidator)
        view = SecurityCodeView(viewModel: testViewModel)
    }

    // Invalid string case of of pre-filled security code text from the merchant.
    func testInValidCodePrefilledTextFieldTextStyle() {
        style.textfield.text = "Test"
        view.update(style: style)
        XCTAssertEqual(view.codeInputView.textFieldView.textField.text, "")
    }

    // Invalid old date case of of pre-filled security code  text from the merchant.
    func testInValid1CodePrefilledTextFieldTextStyle() {
        style.textfield.text = "1"
        view.update(style: style)

        XCTAssertEqual(view.codeInputView.textFieldView.textField.text, "")
    }

    // Valid date case of pre-filled security code  text from the merchant.
    func testValidCodePrefilledTextFieldTextStyle() {
        style.textfield.text = "1234"
        view.update(style: style)

        XCTAssertEqual(view.codeInputView.textFieldView.textField.text, "1234")
    }
}
