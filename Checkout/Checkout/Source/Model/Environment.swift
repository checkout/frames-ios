//
//  Environment.swift
//  
//
//  Created by Harry Brown on 23/11/2021.
//

import Foundation

protocol BaseURLProviding {
  var baseURL: URL { get }
}

/// Environment Enum for Production and Sandbox end points.
public enum Environment: String, BaseURLProviding {
  case production
  case sandbox

  var baseURL: URL {
    switch self {
    case .production:
      return URL(string: "https://api.checkout.com/")
    case .sandbox:
      return URL(string: "https://api.sandbox.checkout.com/")
    }
  }
}
