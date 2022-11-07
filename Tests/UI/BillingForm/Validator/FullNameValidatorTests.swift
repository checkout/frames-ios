import XCTest
@testable import Frames

class FullNameValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCell.fullName(nil)
        let text = ""
        let isInvalid = expectedType.validator.isInvalid(value: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCell.fullName(nil)
        let text = "fullName"
        let isInvalid = expectedType.validator.isInvalid(value: text)
        XCTAssertFalse(isInvalid)
    }
}
