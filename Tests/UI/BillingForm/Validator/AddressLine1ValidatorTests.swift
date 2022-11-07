import XCTest
@testable import Frames

class AddressLine1ValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCell.addressLine1(nil)
        let text = ""
        let isInvalid = expectedType.validator.isInvalid(value: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCell.addressLine1(nil)
        let text = "addressLine1"
        let isInvalid = expectedType.validator.isInvalid(value: text)
        XCTAssertFalse(isInvalid)
    }
}
