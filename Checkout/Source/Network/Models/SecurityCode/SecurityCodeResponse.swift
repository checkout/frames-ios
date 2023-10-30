// 
//  SecurityCodeResponse.swift
//  
//
//  Created by Okhan Okbay on 05/10/2023.
//

import Foundation

public struct SecurityCodeResponse: Decodable, Equatable {
  public let type: String
  public let token: String
  public let expiresOn: String
}
