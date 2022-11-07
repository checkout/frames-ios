import XCTest
@testable import Frames

class CityValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCell.city(nil)
        let text = ""
        let isInvalid = expectedType.validator.isInvalid(value: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCell.city(nil)
        let text = "City"
        let isInvalid = expectedType.validator.isInvalid(value: text)
        XCTAssertFalse(isInvalid)
    }
}
