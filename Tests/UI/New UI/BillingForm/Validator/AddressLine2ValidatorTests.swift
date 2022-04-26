import XCTest
@testable import Frames

class AddressLine2ValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCellType.addressLine2
        let text = ""
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertEqual(isValid, true)
    }
    
    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCellType.addressLine2
        let text = "addressLine2"
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertEqual(isValid, false)
    }
}
