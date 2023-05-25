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
    
    func testUpdateStyleFormatsPhoneNumber() {
        PhoneNumberValidator.shared.countryCode = "GB"
        var style = DefaultBillingFormPhoneNumberCellStyle()
        style.textfield.text = "01206123123"
        let view = BillingFormTextFieldView()
        view.update(style: style, type: .phoneNumber(style), tag: 0)
        
        XCTAssertEqual(view.textField.text, "+44 1206 123123")
    }
    
    func testShouldEndEditingIsFormattingDisplay() {
        PhoneNumberValidator.shared.countryCode = "GB"
        let testTextField = UITextField()
        testTextField.text = "01206123123"
        let view = BillingFormTextFieldView()
        let style = DefaultBillingFormPhoneNumberCellStyle()
        view.update(style: style, type: .phoneNumber(style), tag: 0)
        
        XCTAssertEqual(testTextField.text, "01206123123")
        _ = view.textFieldShouldEndEditing(testTextField)
        XCTAssertEqual(testTextField.text, "+44 1206 123123")
    }
    
    func testChangeCharactersUsingPhoneNumberValidator() {
        let testTextField = UITextField()
        testTextField.text = "01206123123"
        let style = DefaultBillingFormPhoneNumberCellStyle()
        let view = BillingFormTextFieldView()
        view.update(style: style, type: .phoneNumber(style), tag: 0)
        
        var shouldChange = view.textField(testTextField, shouldChangeCharactersIn: NSRange(location: 8, length: 0), replacementString: "2")
        XCTAssertTrue(shouldChange)
        XCTAssertEqual(view.textField.text, "")
        
        shouldChange = view.textField(testTextField, shouldChangeCharactersIn: NSRange(location: 8, length: 0), replacementString: "d")
        XCTAssertFalse(shouldChange)
        XCTAssertEqual(view.textField.text, "")
    }
}
