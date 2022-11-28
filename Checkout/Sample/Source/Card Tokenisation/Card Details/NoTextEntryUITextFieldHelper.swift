//
//  NoTextEntryUITextFieldHelper.swift
//
//
//  Created by Harry Brown on 17/02/2022.
//

import UIKit

final class NoTextEntryUITextFieldHelper: NSObject, UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return false
  }
}
