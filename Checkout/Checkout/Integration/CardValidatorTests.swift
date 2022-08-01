//
//  CardValidatorTests.swift
//  CheckoutIntegrationTests
//
//  Created by Harry Brown on 22/02/2022.
//

import XCTest
import Checkout

final class CardValidatorTests: XCTestCase {
  private let subject = CardValidator(environment: .sandbox)
  private let calendar = Calendar(identifier: .gregorian)

  func test_expiryDate_2040() {
    let result = subject.validate(expiryMonth: 12, expiryYear: 2040)

    switch result {
    case .success(let expiryDate):
      XCTAssertEqual(expiryDate.month, 12)
      XCTAssertEqual(expiryDate.year, 2040)
    case .failure(let error):
      XCTFail("expected success, received error: \(error)")
    }
  }

  func test_expiryDate_nextMonth() {
    let currentDate = Date()
    guard let next = calendar.date(byAdding: .month, value: 1, to: currentDate) else {
      XCTFail("could not build next month date")
      return
    }

    let month = calendar.component(.month, from: next)
    let year = calendar.component(.year, from: next)

    let result = subject.validate(expiryMonth: month, expiryYear: year)

    switch result {
    case .success(let expiryDate):
      XCTAssertEqual(expiryDate.month, month)
      XCTAssertEqual(expiryDate.year, year)
    case .failure(let error):
      XCTFail("expected success, received error: \(error)")
    }
  }

  func test_expiryDate_thisMonth() {
    let currentDate = Date()
    let month = calendar.component(.month, from: currentDate)
    let year = calendar.component(.year, from: currentDate)

    let result = subject.validate(expiryMonth: month, expiryYear: year)

    switch result {
    case .success(let expiryDate):
      XCTAssertEqual(expiryDate.month, month)
      XCTAssertEqual(expiryDate.year, year)
    case .failure(let error):
      XCTFail("expected success, received error: \(error)")
    }
  }

  func test_expiryDate_previousMonth() {
    let utc12SecondOffset: Double = 60 * 60 * 12
    let currentDate = Date(timeInterval: -utc12SecondOffset, since: Date())
    guard let previousMonth = calendar.date(byAdding: .month, value: calendar.component(.day, from: currentDate) > 15 ? -2 : -1, to: currentDate) else {
      XCTFail("could not build next month date")
      return
    }

    let month = calendar.component(.month, from: previousMonth)
    let year = calendar.component(.year, from: previousMonth)

    let result = subject.validate(expiryMonth: month, expiryYear: year)

    XCTAssertEqual(result, .failure(.inThePast))
  }
}
