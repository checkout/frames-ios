import XCTest
@testable import Frames

class PhoneNumberValidatorTests: XCTestCase {

    func testValidationTextWithEmptyString() {
        let expectedType = BillingFormCell.phoneNumber(nil)
        let phone = Phone(number: "", country: Country(iso3166Alpha2: "GB"))
        let isInvalid = expectedType.validator.isInvalid(value: phone)
        XCTAssertTrue(isInvalid)
    }

    func testValidationTextWithString() {
        let expectedType = BillingFormCell.phoneNumber(nil)
        let phone = Phone(number: "ABC", country: Country(iso3166Alpha2: "GB"))
        let isInvalid = expectedType.validator.isInvalid(value: phone)
        XCTAssertTrue(isInvalid)
    }

    func testValidationTextWithLengthLessThan6() {
        let expectedType = BillingFormCell.phoneNumber(nil)
        let phone = Phone(number: "123", country: Country(iso3166Alpha2: "GB"))
        let isInvalid = expectedType.validator.isInvalid(value: phone)
        XCTAssertTrue(isInvalid)
    }

    func testValidationTextWithLengthMoreThan25() {
        let expectedType = BillingFormCell.phoneNumber(nil)
        let phone = Phone(number: "123456789123456789123456789", country: Country(iso3166Alpha2: "GB"))
        let isInvalid = expectedType.validator.isInvalid(value: phone)
        XCTAssertTrue(isInvalid)
    }

    func testValidationWhenTextLengthWithNormalPhoneNumber() {
        let expectedType = BillingFormCell.phoneNumber(nil)
        let phone = Phone(number: "0771245678", country: Country(iso3166Alpha2: "GB"))
        let isInvalid = expectedType.validator.isInvalid(value: phone)
        XCTAssertFalse(isInvalid)
    }
}
