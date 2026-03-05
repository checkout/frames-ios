//
//  Environment.swift
//  
//
//  Created by Harry Brown on 23/11/2021.
//

import Foundation

protocol BaseURLProviding {
  var baseURL: URL? { get }
}

private enum APIHost {
  static let production = "api.checkout.com"
  static let sandbox = "api.sandbox.checkout.com"

  static func prefixed(_ prefix: String, environment: Environment) -> String {
    switch environment {
    case .production:
      return "\(prefix).\(production)"
    case .sandbox:
      return "\(prefix).\(sandbox)"
    }
  }
}

/// Environment Enum for Production and Sandbox end points.
public enum Environment: String, BaseURLProviding {
  case production
  case sandbox

  var baseURL: URL? {
    let host: String
    switch self {
    case .production:
      host = APIHost.production
    case .sandbox:
      host = APIHost.sandbox
    }
    return URL(string: "https://\(host)/")
  }
}

/// Provides a base URL for a given environment, optionally prefixed with a subdomain.
/// When `baseURLPrefix` is set (after trimming), URLs follow the pattern `{prefix}.api[.sandbox].checkout.com`.
struct EnvironmentURLProvider: BaseURLProviding {
  let environment: Environment
  let baseURLPrefix: String?

  var baseURL: URL? {
    let trimmed = baseURLPrefix?.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let prefix = trimmed, !prefix.isEmpty else {
      return environment.baseURL
    }
    let host = APIHost.prefixed(prefix, environment: environment)
    return URL(string: "https://\(host)/")
  }
}
