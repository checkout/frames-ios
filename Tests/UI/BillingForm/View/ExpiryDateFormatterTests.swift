//
//  ExpiryDateFormatterTests.swift
//
//
//  Created by Alex Ioja-Yang on 16/05/2023.
//

import XCTest
import Checkout
@testable import Frames

final class ExpiryDateFormatterTests: XCTestCase {
    
    // MARK: Initialiser Tests
    func testDefaultInitialiser() {
        let validator = ExpiryDateFormatter()
        XCTAssertEqual(validator.dateFormatTextCount, 5)
        XCTAssertEqual(validator.separator, "/")
    }

    func testInitialiserWithCustomSeparator() {
        let separator = " • "
        let validator = ExpiryDateFormatter(componentSeparator: separator)
        XCTAssertEqual(validator.dateFormatTextCount, 7)
        XCTAssertEqual(validator.separator, separator)
    }

    // MARK: Format For Display Tests
    func testInvalidStringInput() {
        let testInput = "agedasve"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertNil(displayString)
    }

    func testInvalidCharacterInput() {
        let testInput = "g"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertNil(displayString)
    }

    func testInvalidNumberInput() {
        let testInput = "0145"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertNil(displayString)
    }

    func testWrongFormatDateInput() {
        let testInput = "01/2088"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertNil(displayString)
    }

    func testValidSingleDigitInput() {
        let testInput = "0"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertEqual(displayString, "0")
    }

    func testInvalidSingleDigitInput() {
        let testInput = "2"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertEqual(displayString, "02/")
    }

    func testInvalidMonthInput() {
        let testInput = "14"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertNil(displayString)
    }

    func testValidMonthInput() {
        let testInput = "11"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertEqual(displayString, "11/")
    }

    func testValidMonthInputWithSlash() {
        let testInput = "11/"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertEqual(displayString, "11/")
    }

    func testValidMonthAndPastDecadeInput() {
        let testInput = "11/1"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertEqual(displayString, "11/1")
    }

    func testValidMonthAndFutureDecadeDigitInput() {
        let testInput = "11/8"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertEqual(displayString, "11/8")
    }

    func testValidMonthAndFullPastYearInput() {
        let testInput = "11/21"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertEqual(displayString, "11/21")
    }

    func testValidMonthAndFullValidYearInput() {
        let testInput = "11/88"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertEqual(displayString, "11/88")
    }

    func testIncompleteMonthAndFullYearInput() {
        let testInput = "2/88"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertEqual(displayString, "02/88")
    }

    func testMixedNumberAndDigitInput() {
        let formatter = ExpiryDateFormatter()
        var testInput = "0k/8l"
        var displayString = formatter.formatForDisplay(input: testInput)
        XCTAssertEqual(displayString, "0")

        testInput = "1k/8l"
        displayString = formatter.formatForDisplay(input: testInput)
        XCTAssertEqual(displayString, "1")

        testInput = "4k/8l"
        displayString = formatter.formatForDisplay(input: testInput)
        XCTAssertEqual(displayString, "04/8")
    }

    func testChangedDateSeparator() {
        let newSeparator = " - "
        let testInput = "12\(newSeparator)67"
        let formatter = ExpiryDateFormatter(componentSeparator: newSeparator)
        let displayString = formatter.formatForDisplay(input: testInput)

        XCTAssertEqual(displayString, "12\(newSeparator)67")
    }

    // MARK: Create Card Expiry Tests
    func testCreateCardExpiryWithEmptyString() {
        let testString = ""
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.createCardExpiry(from: testString)
        XCTAssertEqual(displayString, .failure(.invalidMonth))
    }

    func testCreateCardExpiryWithInvalidInput() {
        let testString = "iojfehnuw43wekjs"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.createCardExpiry(from: testString)
        XCTAssertEqual(displayString, .failure(.invalidMonth))
    }

    func testCreateCardExpiryWithMisformatedInput() {
        let testString = "1026"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.createCardExpiry(from: testString)
        XCTAssertEqual(displayString, .failure(.invalidMonth))
    }

    func testCreateCardExpiryWithMixedNumberAndDigitInput() {
        let testString = "0a/8g"
        let formatter = ExpiryDateFormatter()
        let displayString = formatter.createCardExpiry(from: testString)
        XCTAssertEqual(displayString, .failure(.invalidYear))
    }

    func testCreateCardUsesCardValidatorOutcome() {
        let mockValidator = MockCardValidator()
        let formatter = ExpiryDateFormatter(cardValidator: mockValidator)

        var testString = "01/45"
        mockValidator.validateExpiryStringToReturn = .failure(.incompleteMonth)
        var outcome = formatter.createCardExpiry(from: testString)
        XCTAssertEqual(outcome, .failure(.incompleteMonth))
        XCTAssertEqual(mockValidator.validateExpiryStringCalledWith?.expiryMonth, "01")
        XCTAssertEqual(mockValidator.validateExpiryStringCalledWith?.expiryYear, "45")

        testString = "03/44"
        mockValidator.validateExpiryStringToReturn = .success(ExpiryDate(month: 1, year: 12))
        outcome = formatter.createCardExpiry(from: testString)
        XCTAssertEqual(outcome, .success(ExpiryDate(month: 1, year: 12)))
        XCTAssertEqual(mockValidator.validateExpiryStringCalledWith?.expiryMonth, "03")
        XCTAssertEqual(mockValidator.validateExpiryStringCalledWith?.expiryYear, "44")
    }
}
