import XCTest
@testable import Frames

class PostcodeValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCell.postcode(nil)
        let text = ""
        let isValid = expectedType.validator.validate(value: text)
        XCTAssertFalse(isValid)
    }

    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCell.postcode(nil)
        let text = "postcode"
        let isValid = expectedType.validator.validate(value: text)
        XCTAssertTrue(isValid)
    }
}
