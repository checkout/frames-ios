// 
//  SecurityCodeTokenDetails.swift
//  
//
//  Created by Okhan Okbay on 10/10/2023.
//

import Checkout
import Foundation

public struct SecurityCodeTokenDetails {
  public let type: String
  public let token: String
  public let expiresOn: String

  init(type: String, token: String, expiresOn: String) {
    self.type = type
    self.token = token
    self.expiresOn = expiresOn
  }

  init(response: SecurityCodeResponse) {
    self.type = response.type
    self.token = response.token
    self.expiresOn = response.expiresOn
  }
}
