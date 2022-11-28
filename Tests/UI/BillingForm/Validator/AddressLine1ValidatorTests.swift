import XCTest
@testable import Frames

class AddressLine1ValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCell.addressLine1(nil)
        let text = ""
        let isValid = expectedType.validator.validate(value: text)
        XCTAssertFalse(isValid)
    }

    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCell.addressLine1(nil)
        let text = "addressLine1"
        let isValid = expectedType.validator.validate(value: text)
        XCTAssertTrue(isValid)
    }
}
