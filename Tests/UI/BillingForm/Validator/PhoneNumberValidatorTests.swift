import XCTest
@testable import Frames

class PhoneNumberValidatorTests: XCTestCase {

    func testValidationTextWithEmptyString() {
        let expectedType = BillingFormCell.phoneNumber(nil)
        let text = ""
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationTextWithString() {
        let expectedType = BillingFormCell.phoneNumber(nil)
        let text = "ABC"
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationTextWithLengthLessThan6() {
        let expectedType = BillingFormCell.phoneNumber(nil)
        let text = "134"
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationTextWithLengthMoreThan25() {
        let expectedType = BillingFormCell.phoneNumber(nil)
        let text = "123456789123456789123456789"
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationWhenTextLengthWithNormalPhoneNumber() {
        let expectedType = BillingFormCell.phoneNumber(nil)
        let text = "0771245678"
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertFalse(isInvalid)
    }
}
