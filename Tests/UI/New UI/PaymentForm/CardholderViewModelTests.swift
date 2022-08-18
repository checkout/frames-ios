//
//  CardholderViewModelTests.swift
//  
//
//  Created by Alex Ioja-Yang on 18/08/2022.
//

import XCTest
@testable import Frames

final class CardholderViewModelTests: XCTestCase {
    
    func testInputUpdateCallsDelegate() {
        let mockDelegate = MockCardholderDelegate()
        let model = CardholderViewModel()
        model.delegate = mockDelegate
        
        let testExpectation = expectation(description: "Should call delegate completion")
        mockDelegate.cardhodlerUpdatedCompletion = {
            testExpectation.fulfill()
        }
        
        let testArgument = "card owner"
        model.inputUpdated(to: testArgument)
        waitForExpectations(timeout: 0.1)
    
        XCTAssertEqual(mockDelegate.cardholderUpdatedReceivedArguments, [testArgument])
    }
    
}
