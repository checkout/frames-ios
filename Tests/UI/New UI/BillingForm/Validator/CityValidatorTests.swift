import XCTest
@testable import Frames

class CityValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCellType.city
        let text = ""
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertTrue(isValid)
    }
    
    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCellType.city
        let text = "City"
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertFalse(isValid)
    }
}
