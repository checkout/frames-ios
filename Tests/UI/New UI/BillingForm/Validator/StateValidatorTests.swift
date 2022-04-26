import XCTest
@testable import Frames

class StateValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCellType.state
        let text = ""
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertEqual(isValid, true)
    }
    
    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCellType.state
        let text = "postcode"
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertEqual(isValid, false)
    }
}
