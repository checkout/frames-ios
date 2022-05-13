//
//  StubError.swift
//  
//
//  Created by Harry Brown on 02/12/2021.
//

import Foundation

enum StubError: LocalizedError {
  case one

  var errorDescription: String? {
    switch self {
    case .one:
      return "StubError.one"
    }
  }
}
