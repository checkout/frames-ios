//
//  MockPaymentViewModelDelegate.swift
//  
//
//  Created by Alex Ioja-Yang on 28/12/2022.
//

import XCTest
@testable import Frames

final class MockPaymentViewModelDelegate: PaymentViewModelDelegate {
    var loadingStateChangedCompletion: (() -> Void) = { XCTFail("Not expected to occur") }
    var updateEditBillingSummaryCompletion: (() -> Void) = { XCTFail("Not expected to occur") }
    var updateAddBillingDetailsCompletion: (() -> Void) = { XCTFail("Not expected to occur") }
    var updateExpiryDateCompletion: (() -> Void) = { XCTFail("Not expected to occur") }
    var updateCardholderCompletion: (() -> Void) = { XCTFail("Not expected to occur") }
    var updateCardNumberCompletion: (() -> Void) = { XCTFail("Not expected to occur") }
    var updateCardSchemeCompletion: ((Frames.Card.Scheme) -> Void) = { _ in XCTFail("Not expected to occur") }
    var updateSecurityCodeCompletion: (() -> Void) = { XCTFail("Not expected to occur") }
    var updatePayButtonCompletion: (() -> Void) = { XCTFail("Not expected to occur") }
    var updateHeaderCompletion: (() -> Void) = { XCTFail("Not expected to occur") }
    var refreshPayButtonStateCompletion: ((Bool) -> Void) = { _ in XCTFail("Not expected to occur") }
    
    func loadingStateChanged() {
        loadingStateChangedCompletion()
    }
    
    func updateEditBillingSummary() {
        updateEditBillingSummaryCompletion()
    }
    
    func updateAddBillingDetails() {
        updateAddBillingDetailsCompletion()
    }
    
    func updateExpiryDate() {
        updateExpiryDateCompletion()
    }
    
    func updateCardholder() {
        updateCardholderCompletion()
    }
    
    func updateCardNumber() {
        updateCardNumberCompletion()
    }
    
    func updateCardScheme(_ newScheme: Frames.Card.Scheme) {
        updateCardSchemeCompletion(newScheme)
    }
    
    func updateSecurityCode() {
        updateSecurityCodeCompletion()
    }
    
    func updatePayButton() {
        updatePayButtonCompletion()
    }
    
    func updateHeader() {
        updateHeaderCompletion()
    }
    
    func refreshPayButtonState(isEnabled: Bool) {
        refreshPayButtonStateCompletion(isEnabled)
    }
    
}
