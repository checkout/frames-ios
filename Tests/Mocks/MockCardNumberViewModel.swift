//
//  MockCardNumberViewModel.swift
//  FramesTests
//
//  Created by Harry Brown on 13/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

@testable import Frames

final class MockCardNumberViewModel: CardNumberViewModelProtocol {
  private(set) var textFieldUpdateCalledWith: String?
  var textFieldUpdateToReturn: String?

  func textFieldUpdate(from text: String) -> String? {
    textFieldUpdateCalledWith = text
    return textFieldUpdateToReturn
  }
}
