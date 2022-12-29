//
//  MockPaymentViewModel.swift
//  
//
//  Created by Alex Ioja-Yang on 29/12/2022.
//

import XCTest
import Checkout
@testable import Frames

final class MockPaymentViewModel: PaymentViewModel {
    var delegate: PaymentViewModelDelegate?
    var paymentFormStyle: PaymentFormStyle?
    var billingFormStyle: BillingFormStyle?
    var supportedSchemes: [Card.Scheme] = []
    var cardValidator: CardValidating = MockCardValidator()
    var isLoading: Bool = false
    var cardTokenRequested: ((Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)?
    
    var viewControllerWillAppearCompletion: (() -> Void) = { XCTFail("Not expected to be called") }
    var viewControllerCancelledCompletion: (() -> Void) = { XCTFail("Not expected to be called") }
    var updateBillingSummaryViewCompletion: (() -> Void) = { XCTFail("Not expected to be called") }
    var presentBillingCompletion: ((UIPresenter) -> Void) = { _ in XCTFail("Not expected to be called") }
    var expiryDateIsUpdatedCompletion: ((Result<ExpiryDate, ExpiryDateError>) -> Void) = { _ in XCTFail("Not expected to be called") }
    var securityCodeIsUpdatedCompletion: ((String) -> Void) = { _ in XCTFail("Not expected to be called") }
    var cardholderIsUpdatedCompletion: ((String) -> Void) = { _ in XCTFail("Not expected to be called") }
    var payButtonIsPressedCompletion: (() -> Void) = { XCTFail("Not expected to be called") }
    
    func viewControllerWillAppear() {
        viewControllerWillAppearCompletion()
    }
    
    func viewControllerCancelled() {
        viewControllerCancelledCompletion()
    }
    
    func updateBillingSummaryView() {
        updateBillingSummaryViewCompletion()
    }
    
    func presentBilling(presenter: UIPresenter) {
        presentBillingCompletion(presenter)
    }
    
    func expiryDateIsUpdated(result: Result<ExpiryDate, ExpiryDateError>) {
        expiryDateIsUpdatedCompletion(result)
    }
    
    func securityCodeIsUpdated(to newCode: String) {
        securityCodeIsUpdatedCompletion(newCode)
    }
    
    func cardholderIsUpdated(value: String) {
        cardholderIsUpdatedCompletion(value)
    }
    
    func payButtonIsPressed() {
        payButtonIsPressedCompletion()
    }
    
}
