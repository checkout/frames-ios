import XCTest
@testable import Frames

class BillingFormTextFieldViewTests: XCTestCase {
    var view: BillingFormTextFieldView!
    var style: DefaultBillingFormFullNameCellStyle!

    override func setUp() {
        super.setUp()
        style = DefaultBillingFormFullNameCellStyle()
        view = BillingFormTextFieldView()
        view.update(style: style, type: .fullName(nil), tag: 0)
    }

    func testHeaderLabelStyle() {
        XCTAssertEqual(view.headerLabel.label.text, style.title?.text)
        XCTAssertEqual(view.headerLabel.label.font, style.title?.font)
        XCTAssertEqual(view.headerLabel.label.textColor, style.title?.textColor)
    }

    func testHintLabelStyle() {
        XCTAssertEqual(view.hintLabel.label.text, style.hint?.text)
    }

    func testTextFieldContainerStyle() {
        XCTAssertEqual(view.textFieldContainer.backgroundColor, style.textfield.backgroundColor)
        XCTAssertEqual(view.textFieldContainer.layer.borderColor, style.textfield.borderStyle.normalColor.cgColor)
        XCTAssertEqual(view.textFieldContainer.layer.cornerRadius, style.textfield.borderStyle.cornerRadius)
        XCTAssertEqual(view.textFieldContainer.layer.borderWidth, style.textfield.borderStyle.borderWidth)
        XCTAssertEqual(view.textFieldContainer.layer.cornerRadius, style.textfield.borderStyle.cornerRadius)
        XCTAssertEqual(view.textFieldContainer.layer.borderWidth, style.textfield.borderStyle.borderWidth)
        XCTAssertEqual(view.textField.keyboardType, .default)
        XCTAssertEqual(view.textField.textContentType, .name)
    }

    func testTextFieldStyle() {
        XCTAssertEqual(view.textField.text, style.textfield.text)
        XCTAssertEqual(view.textField.font, style.textfield.font)
        XCTAssertNil(view.textField.placeholder)
        XCTAssertEqual(view.textField.textColor, style.textfield.textColor)
        XCTAssertEqual(view.textField.tintColor, style.textfield.tintColor)
    }
    
    func testPhoneNumberInputStyle() {
        style = DefaultBillingFormFullNameCellStyle()
        view = BillingFormTextFieldView()
        view.update(style: style, type: .phoneNumber(nil), tag: 0)
        
        XCTAssertNotNil(view.phoneNumberTextField)
        XCTAssertEqual(view.phoneNumberTextField?.isHidden, false)
        XCTAssertTrue(view.textField.isHidden)
        XCTAssertEqual(view.textFieldContainer.subviews.count, 2)
        
        view.refreshLayoutComponents()
        XCTAssertNotNil(view.phoneNumberTextField)
        XCTAssertEqual(view.phoneNumberTextField?.isHidden, false)
        XCTAssertTrue(view.textField.isHidden)
        XCTAssertEqual(view.textFieldContainer.subviews.count, 2)
    }

    func testNotPhoneNumberInputStyle() {
        style = DefaultBillingFormFullNameCellStyle()
        view = BillingFormTextFieldView()
        view.update(style: style, type: .city(nil), tag: 0)
        
        XCTAssertNil(view.phoneNumberTextField)
        XCTAssertFalse(view.textField.isHidden)
        XCTAssertEqual(view.textFieldContainer.subviews.count, 1)
        
        view.refreshLayoutComponents()
        XCTAssertNil(view.phoneNumberTextField)
        XCTAssertFalse(view.textField.isHidden)
        XCTAssertEqual(view.textFieldContainer.subviews.count, 1)
    }
    
    func testChangingFromTypeToType() {
        style = DefaultBillingFormFullNameCellStyle()
        view = BillingFormTextFieldView()
        view.update(style: style, type: .city(nil), tag: 0)
        
        XCTAssertNil(view.phoneNumberTextField)
        XCTAssertFalse(view.textField.isHidden)
        XCTAssertEqual(view.textFieldContainer.subviews.count, 1)
        
        view.update(style: style, type: .phoneNumber(nil), tag: 0)
        XCTAssertNotNil(view.phoneNumberTextField)
        XCTAssertEqual(view.phoneNumberTextField?.isHidden, false)
        XCTAssertTrue(view.textField.isHidden)
        XCTAssertEqual(view.textFieldContainer.subviews.count, 2)
        
        view.update(style: style, type: .state(nil), tag: 0)
        XCTAssertNil(view.phoneNumberTextField)
        XCTAssertFalse(view.textField.isHidden)
        XCTAssertEqual(view.textFieldContainer.subviews.count, 1)
    }
}
