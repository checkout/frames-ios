import XCTest
@testable import Frames

class BillingFormCellTests: XCTestCase {

    func testFullNameValidatorType() {
        XCTAssertTrue(BillingFormCell.fullName(nil).validator is GenericInputValidator)
    }

    func testaddressLine1ValidatorType() {
        XCTAssertTrue(BillingFormCell.addressLine1(nil).validator is GenericInputValidator)
    }

    func testaddressLine2ValidatorType() {
        XCTAssertTrue(BillingFormCell.addressLine2(nil).validator is GenericInputValidator)
    }

    func testCityValidatorType() {
        XCTAssertTrue(BillingFormCell.city(nil).validator is GenericInputValidator)
    }

    func testStateValidatorType() {
        XCTAssertTrue(BillingFormCell.state(nil).validator is GenericInputValidator)
    }

    func testCountryValidatorType() {
        XCTAssertTrue(BillingFormCell.country(nil).validator is GenericInputValidator)
    }

    func testPostcodeValidatorType() {
        XCTAssertTrue(BillingFormCell.postcode(nil).validator is GenericInputValidator)
    }

    func testPhoneNumberValidatorType() {
        XCTAssertTrue(BillingFormCell.phoneNumber(nil).validator is PhoneNumberValidator)
    }
}
