//
//  MockCardNumberViewModel.swift
//  FramesTests
//
//  Created by Harry Brown on 13/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

@testable import Frames

final class MockCardNumberViewModel: CardNumberViewModelProtocol {
  private(set) var validateCalledWith: String?
  var validateToReturn: Constants.Bundle.SchemeIcon?

  private(set) var eagerValidateCalledWith: String?
  var eagerValidateToReturn: (newTextFieldValue: String, schemeIcon: Constants.Bundle.SchemeIcon)?

  func validate(cardNumber: String) -> Constants.Bundle.SchemeIcon? {
    validateCalledWith = cardNumber
    return validateToReturn
  }

  func eagerValidate(cardNumber: String) -> (newTextFieldValue: String, schemeIcon: Constants.Bundle.SchemeIcon)? {
    eagerValidateCalledWith = cardNumber
    return eagerValidateToReturn
  }
}
