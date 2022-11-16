//
//  SecurityCodeViewModelTests.swift
//  
//
//  Created by Alex Ioja-Yang on 28/07/2022.
//

import XCTest
@testable import Frames
@testable import Checkout

final class SecurityCodeViewModelTests: XCTestCase {
    
    func testValidateEmptyStringExpectedTrue() {
        let string = ""
        let model = createViewModel(maximumCVVLenght: 3, isCVVInputValid: true)
        model.updateInput(to: string)
        
        XCTAssertEqual(model.cvv, "")
        XCTAssertTrue(model.isInputValid)
    }
    
    func testValidateEmptyStringExpectedFalse() {
        let string = ""
        let model = createViewModel(maximumCVVLenght: 3, isCVVInputValid: false)
        model.updateInput(to: string)
        
        XCTAssertEqual(model.cvv, "")
        XCTAssertFalse(model.isInputValid)
    }
    
    func testValidateWhitespaceString() {
        let string = " 1 "
        let model = createViewModel(maximumCVVLenght: 3)
        model.updateInput(to: string)
        
        XCTAssertEqual(model.cvv, "1")
    }
    
    func testValidateCodeReachingMaximumCVVLenght() {
        let string = "231"
        let model = createViewModel(maximumCVVLenght: 3)
        model.updateInput(to: string)
        
        XCTAssertEqual(model.cvv, "231")
    }
    
    func testValidateCodeOverMaximumCVVLenght() {
        let string = "2314"
        let model = createViewModel(maximumCVVLenght: 3)
        model.updateInput(to: string)
        
        XCTAssertEqual(model.cvv, "")
    }
    
    func testValidateStringInput() {
        let string = "str"
        let model = createViewModel()
        model.updateScheme(to: .mastercard)
        model.updateInput(to: string)
        
        XCTAssertEqual(model.cvv, "")
    }
    
    func testValidateSpecialCharacter() {
        let string = "$23"
        let model = createViewModel()
        model.updateScheme(to: .mastercard)
        model.updateInput(to: string)
        
        XCTAssertEqual(model.cvv, "23")
    }
    
    func testValidateDecimalInput() {
        let string = "2.31"
        let model = createViewModel()
        model.updateScheme(to: .mastercard)
        model.updateInput(to: string)
        
        XCTAssertEqual(model.cvv, "231")
    }

    func testValidateZeroDecimalInput() {
        let string = "0000"
        let model = createViewModel(maximumCVVLenght: 4)
        model.updateInput(to: string)

        XCTAssertEqual(model.cvv, "0000")
    }
    
    func testValidateNegativeNumberInput() {
        let string = "-63"
        let model = createViewModel()
        model.updateScheme(to: .mastercard)
        model.updateInput(to: string)
        
        XCTAssertEqual(model.cvv, "63")
    }

    func testValidateInputNumberAfterDeleting() {
        let model = createViewModel()
        model.updateScheme(to: .mastercard)

        model.updateInput(to: "00")
        XCTAssertEqual(model.cvv, "00")

        model.updateInput(to: "")
        XCTAssertEqual(model.cvv, "")

        model.updateInput(to: "1")
        XCTAssertEqual(model.cvv, "1")
    }
    
    func testUpdateWithNewScheme() {
        let model = createViewModel()
        let expect = expectation(description: "Should call delegate completion handler")
        let fakeDelegate = MockSecurityCodeDelegate()
        fakeDelegate.schemeChangedCompletion = {
            expect.fulfill()
        }
        model.delegate = fakeDelegate
        
        // Test assumes this is not the default scheme
        model.updateScheme(to: .americanExpress)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testUpdateWithExistingScheme() {
        let model = createViewModel()
        let fakeDelegate = MockSecurityCodeDelegate()
        fakeDelegate.schemeChangedCompletion = {
            XCTFail()
        }
        model.delegate = fakeDelegate
        
        // Test assumes this is default scheme
        model.updateScheme(to: .unknown)
    }
    
    func testValidInputBecomesInvalidForNewScheme() {
        let mockValidator = MockCardValidator()
        let model = SecurityCodeViewModel(cardValidator: mockValidator)
        mockValidator.validateCVVToReturn = .success
        
        model.updateInput(to: "123")
        XCTAssertTrue(model.isInputValid)
        XCTAssertEqual(model.cvv, "123")
        
        mockValidator.validateCVVToReturn = .failure(.invalidLength)
        model.updateScheme(to: .mada)
        XCTAssertFalse(model.isInputValid)
        XCTAssertEqual(model.cvv, "123")
    }
    
    
    private func createViewModel(mockValidator: MockCardValidator = MockCardValidator(),
                                 maximumCVVLenght: Int = 3,
                                 isCVVInputValid: Bool = true) -> SecurityCodeViewModel {
        
        mockValidator.validateCVVToReturn = isCVVInputValid ? .success : .failure(.invalidLength)
        mockValidator.expectedMaxLenghtCVV = maximumCVVLenght
        return SecurityCodeViewModel(cardValidator: mockValidator)
    }
}
