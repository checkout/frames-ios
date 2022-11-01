import XCTest
@testable import Frames

class AddressLine2ValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCell.addressLine2(nil)
        let text = ""
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCell.addressLine2(nil)
        let text = "addressLine2"
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertFalse(isInvalid)
    }
}
