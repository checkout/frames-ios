import XCTest
@testable import Frames

class CountryValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCellType.country
        let text = ""
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertTrue(isValid)
    }
    
    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCellType.country
        let text = "Country"
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertFalse(isValid)
    }
}
