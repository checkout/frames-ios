// 
//  SecurityCodeRequest.swift
//  
//
//  Created by Okhan Okbay on 05/10/2023.
//

import Foundation

struct SecurityCodeRequest: Encodable, Equatable {
  let type: String = "cvv"
  let tokenData: TokenData
}

struct TokenData: Encodable, Equatable {
  let securityCode: String

  enum CodingKeys: String, CodingKey {
    case securityCode = "cvv"
  }
}

// For logging purposes only
enum SecurityCodeTokenType: String, Codable, Equatable {
  case cvv
}
