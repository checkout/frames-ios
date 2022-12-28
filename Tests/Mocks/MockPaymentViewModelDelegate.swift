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
    var updateCardholderCompletion: (() -> Void) = { XCTFail("Not expected to occur") }
    var updateCardSchemeCompletion: ((Frames.Card.Scheme) -> Void) = { _ in XCTFail("Not expected to occur") }
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
    
    func updateCardholder() {
        updateCardholderCompletion()
    }
    
    func updateCardScheme(_ newScheme: Frames.Card.Scheme) {
        updateCardSchemeCompletion(newScheme)
    }
    
    func refreshPayButtonState(isEnabled: Bool) {
        refreshPayButtonStateCompletion(isEnabled)
    }
    
}
