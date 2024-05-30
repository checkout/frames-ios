//
//  CheckoutLogEvent.swift
//  
//
//  Created by Harry Brown on 10/12/2021.
//

import Foundation
import CheckoutEventLoggerKit

enum CheckoutLogEvent: Equatable {
  case tokenRequested(TokenRequestData)
  case tokenResponse(TokenRequestData, TokenResponseData)
  case cardValidator
  case validateCardNumber
  case validateExpiryString
  case validateExpiryInteger
  case validateCVV
  case cvvRequested(SecurityCodeTokenRequestData)
  case cvvResponse(SecurityCodeTokenRequestData, TokenResponseData)
  case riskSDKCompletion

  func event(date: Date) -> Event {
    Event(
      typeIdentifier: typeIdentifier,
      time: date,
      monitoringLevel: monitoringLevel,
      properties: properties.unpackEnumKeys().mapValues(CheckoutEventLoggerKit.AnyCodable.init(_:)))
  }

  var sendEveryTime: Bool {
    switch self {
    case .cardValidator,
      .validateCardNumber,
      .validateExpiryString,
      .validateCVV:
      return false
    default:
      return true
    }
  }

  private var typeIdentifier: String {
    switch self {
    case .tokenRequested, .cvvRequested:
      return "token_requested"
    case .tokenResponse, .cvvResponse:
      return "token_response"
    case .cardValidator:
      return "card_validator"
    case .validateCardNumber:
      return "card_validator_card_number"
    case .validateExpiryString:
      return "card_validator_expiry_string"
    case .validateExpiryInteger:
      return "card_validator_expiry_integer"
    case .validateCVV:
      return "card_validator_cvv"
    case .riskSDKCompletion:
      return "risk_sdk_completion"
    }
  }

  private var monitoringLevel: MonitoringLevel {
    switch self {
    case .tokenRequested,
      .cardValidator,
      .validateCardNumber,
      .validateExpiryString,
      .validateExpiryInteger,
      .validateCVV,
      .cvvRequested,
      .riskSDKCompletion:
      return .info
    case .tokenResponse(_, let tokenResponseData),
        .cvvResponse(_, let tokenResponseData):
      return level(from: tokenResponseData.httpStatusCode)
    }
  }

  private func level(from httpStatusCode: Int?) -> MonitoringLevel {
    guard let httpStatusCode = httpStatusCode else {
      return .info
    }

    return 200..<300 ~= httpStatusCode ? .info : .error
  }

  private var properties: [PropertyKey: Any] {
    switch self {
    case .cardValidator,
      .validateCardNumber,
      .validateExpiryString,
      .validateExpiryInteger,
      .validateCVV,
      .riskSDKCompletion:
      return [:]
    case let .tokenRequested(tokenRequestData):
      return [
        .tokenType: tokenRequestData.tokenType?.rawValue.lowercased(),
        .publicKey: tokenRequestData.publicKey
      ].compactMapValues { $0 }
    case let .tokenResponse(tokenRequestData, tokenResponseData):
      return mergeDictionaries(
        [
          .tokenType: tokenRequestData.tokenType?.rawValue.lowercased(),
          .publicKey: tokenRequestData.publicKey,
          .tokenID: tokenResponseData.tokenID,
          .scheme: tokenResponseData.scheme
        ],
        [.httpStatusCode: tokenResponseData.httpStatusCode],
        [.serverError: tokenResponseData.serverError]
      )
    case .cvvRequested(let tokenRequestData):
      return [
        .tokenType: tokenRequestData.tokenType?.rawValue.lowercased(),
        .publicKey: tokenRequestData.publicKey
      ].compactMapValues { $0 }

    case let .cvvResponse(tokenRequestData, tokenResponseData):
      return mergeDictionaries(
        [
          .tokenType: tokenRequestData.tokenType?.rawValue.lowercased(),
          .publicKey: tokenRequestData.publicKey,
          .tokenID: tokenResponseData.tokenID,
          .scheme: tokenResponseData.scheme
        ],
        [.httpStatusCode: tokenResponseData.httpStatusCode],
        [.serverError: tokenResponseData.serverError]
      )
    }
  }

  private enum PropertyKey: String {
    case tokenType
    case publicKey
    case tokenID
    case scheme
    case httpStatusCode
    case serverError
  }

  private func mergeDictionaries<Key, Value>(_ dictionaries: [Key: Value?]...) -> [Key: Value] {
    return dictionaries.reduce([:]) { result, current in
      return result.merging(current.compactMapValues { $0 }) { _, new in new }
    }
  }
}
