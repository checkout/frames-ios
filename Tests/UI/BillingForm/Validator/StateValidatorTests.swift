import XCTest
@testable import Frames

class StateValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCell.state(nil)
        let text = ""
        let isInvalid = expectedType.validator.isInvalid(value: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCell.state(nil)
        let text = "postcode"
        let isInvalid = expectedType.validator.isInvalid(value: text)
        XCTAssertFalse(isInvalid)
    }
}
