import XCTest
@testable import Frames

class FullNameValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCell.fullName(nil)
        let text = ""
        let isValid = expectedType.validator.validate(value: text)
        XCTAssertFalse(isValid)
    }

    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCell.fullName(nil)
        let text = "fullName"
        let isValid = expectedType.validator.validate(value: text)
        XCTAssertTrue(isValid)
    }
}
