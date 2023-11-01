// 
//  SecurityCodeResponse.swift
//  
//
//  Created by Okhan Okbay on 05/10/2023.
//

import Foundation

public struct SecurityCodeResponse: Decodable, Equatable {
  /// Type of the tokenisation. In SecurityCodeResponse, it's always `cvv`
  public let type: String

  /// Reference token
  public let token: String

  /// Date/time of the token expiration. The format is `2023-11-01T13:36:16.2003858Z`
  public let expiresOn: String
}
