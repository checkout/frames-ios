//
//  NetworkError.swift
//  
//
//  Created by Harry Brown on 24/11/2021.
//

import Foundation

/// Defines the network error - list below.
public enum NetworkError: CheckoutError {
  case noInternetConnectivity
  case connectionFailed
  case connectionTimeout
  case connectionLost
  case internationalRoamingOff
  case unknown(additionalInfo: String, error: Error?)
  case certificateTransparencyChecksFailed
  case couldNotDecodeValues
  case emptyResponse

  public var code: Int {
    switch self {
    case .noInternetConnectivity:
      return 2000
    case .connectionFailed:
      return 2001
    case .connectionTimeout:
      return 2002
    case .connectionLost:
      return 2003
    case .internationalRoamingOff:
      return 2004
    case .unknown:
      return 2005
    case .certificateTransparencyChecksFailed:
      return 2006
    case .couldNotDecodeValues:
      return 2007
    case .emptyResponse:
      return 2008
    }
  }

  public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
    switch (lhs, rhs) {
    case (.noInternetConnectivity, .noInternetConnectivity),
      (.connectionFailed, .connectionFailed),
      (.connectionTimeout, .connectionTimeout),
      (.connectionLost, .connectionLost),
      (.internationalRoamingOff, .internationalRoamingOff),
      (.certificateTransparencyChecksFailed, .certificateTransparencyChecksFailed),
      (.couldNotDecodeValues, .couldNotDecodeValues),
      (.emptyResponse, .emptyResponse):
      return true

    case let (.unknown(lhsAdditionalInfo, _), .unknown(rhsAdditionalInfo, _)):
      return lhsAdditionalInfo == rhsAdditionalInfo

    case (.noInternetConnectivity, _),
      (.connectionFailed, _),
      (.connectionTimeout, _),
      (.connectionLost, _),
      (.internationalRoamingOff, _),
      (.certificateTransparencyChecksFailed, _),
      (.couldNotDecodeValues, _),
      (.emptyResponse, _),
      (.unknown, _):
      return false
    }
  }
}
