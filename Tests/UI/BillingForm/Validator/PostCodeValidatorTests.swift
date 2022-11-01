import XCTest
@testable import Frames

class PostcodeValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCell.postcode(nil)
        let text = ""
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCell.postcode(nil)
        let text = "postcode"
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertFalse(isInvalid)
    }
}
