// 
//  SecurityCodeResponse.swift
//  
//
//  Created by Okhan Okbay on 05/10/2023.
//

import Foundation

struct SecurityCodeResponse: Decodable {
  let type: String
  let token: String
  let expiresOn: String
}
