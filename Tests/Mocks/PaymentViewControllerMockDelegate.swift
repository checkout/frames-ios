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
  var expiryDateIsUpdatedWithValue: [ExpiryDate?] = []
  var securityCodeIsUpdatedWithValue: [String?] = []
  var cardNumberIsUpdatedWithValue: [String?] = []
  var payButtonIsPressedCounter: Int = 0

  func addBillingButtonIsPressed(sender: UINavigationController?) {
    addBillingButtonIsPressedWithSender.append(sender)
  }

  func editBillingButtonIsPressed(sender: UINavigationController?) {
    editBillingButtonIsPressedWithSender.append(sender)
  }

  func expiryDateIsUpdated(value: ExpiryDate?) {
    expiryDateIsUpdatedWithValue.append(value)
  }

  func securityCodeIsUpdated(value: String?) {
    securityCodeIsUpdatedWithValue.append(value)
  }

  func cardNumberIsUpdated(value: String?) {
    cardNumberIsUpdatedWithValue.append(value)
  }

  func payButtonIsPressed() {
    payButtonIsPressedCounter += 1
  }

}
