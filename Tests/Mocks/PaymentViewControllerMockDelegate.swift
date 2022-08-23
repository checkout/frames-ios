//
//  PaymentViewControllerMockDelegate.swift
//  FramesTests
//
//  Created by Ehab Alsharkawy.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit
import Checkout
@testable import Frames

class PaymentViewControllerMockDelegate: PaymentViewControllerDelegate {
    var addBillingButtonIsPressedWithSender: [UINavigationController?] = []
    var editBillingButtonIsPressedWithSender: [UINavigationController?] = []
    var expiryDateIsUpdatedWithValue: [Result<ExpiryDate, ExpiryDateError>] = []
    var securityCodeIsUpdatedWithValue: [Result<String, SecurityCodeError>] = []
    var cardholderIsUpdatedWithValue: [String] = []
    var payButtonIsPressedCounter: Int = 0
    var cardholderIsUpdatedCompletionHandler: (() -> Void)?

    func addBillingButtonIsPressed(sender: UINavigationController?) {
        addBillingButtonIsPressedWithSender.append(sender)
    }

    func editBillingButtonIsPressed(sender: UINavigationController?) {
        editBillingButtonIsPressedWithSender.append(sender)
    }

    func expiryDateIsUpdated(result: Result<ExpiryDate, ExpiryDateError>) {
        expiryDateIsUpdatedWithValue.append(result)
    }

    func securityCodeIsUpdated(result: Result<String, SecurityCodeError>) {
        securityCodeIsUpdatedWithValue.append(result)
    }

    func cardholderIsUpdated(value: String) {
        cardholderIsUpdatedWithValue.append(value)
        cardholderIsUpdatedCompletionHandler?()
    }

    func payButtonIsPressed() {
        payButtonIsPressedCounter += 1
    }
}
