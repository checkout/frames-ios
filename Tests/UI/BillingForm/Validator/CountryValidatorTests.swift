import XCTest
@testable import Frames

class CountryValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCell.country(nil)
        let text = ""
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertTrue(isInvalid)
    }

    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCell.country(nil)
        let text = "Country"
        let isInvalid = expectedType.validator.isInvalid(text: text)
        XCTAssertFalse(isInvalid)
    }
}
