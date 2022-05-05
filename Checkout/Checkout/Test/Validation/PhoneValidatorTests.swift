//
//  PhoneValidatorTests.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import XCTest
@testable import Checkout

// swiftlint:disable force_unwrapping
final class PhoneValidatorTests: XCTestCase {
  private let subject = PhoneValidator()

  func test_validate_numberTooShort_returnsCorrectFailure() {
    let number = String((0..<Constants.Phone.phoneMinLength - 1).map { _ in "0123456789".randomElement()! })
    let phone = Phone(number: number, country: nil)

    switch subject.validate(phone) {
    case .success:
      XCTFail("Unexpected success.")
    case .failure(let error):
      XCTAssertEqual(error, .numberIncorrectLength)
    }
  }

  func test_validate_numberTooLong_returnsCorrectFailure() {
    let number = String((0..<Constants.Phone.phoneMaxLength + 1).map { _ in "0123456789".randomElement()! })
    let phone = Phone(number: number, country: nil)

    switch subject.validate(phone) {
    case .success:
      XCTFail("Unexpected success.")
    case .failure(let error):
      XCTAssertEqual(error, .numberIncorrectLength)
    }
  }

  func test_validate_dialCodeTooShort_returnsCorrectFailure() {
    let number = String((0..<Constants.Phone.phoneMinLength).map { _ in "0123456789".randomElement()! })
    let dialCode = String((0..<Constants.Phone.countryCodeMinLength - 1).map { _ in "0123456789".randomElement()! })

    let phone = Phone(number: number, country: Country(iso3166Alpha2: "", dialingCode: dialCode))

    switch subject.validate(phone) {
    case .success:
      XCTFail("Unexpected success.")
    case .failure(let error):
      XCTAssertEqual(error, .countryCodeIncorrectLength)
    }
  }

  func test_validate_dialCodeTooLong_returnsCorrectFailure() {
    let number = String((0..<Constants.Phone.phoneMinLength).map { _ in "0123456789".randomElement()! })
    let dialCode = String((0..<Constants.Phone.countryCodeMaxLength + 1).map { _ in "0123456789".randomElement()! })

    let phone = Phone(number: number, country: Country(iso3166Alpha2: "", dialingCode: dialCode))

    switch subject.validate(phone) {
    case .success:
      XCTFail("Unexpected success.")
    case .failure(let error):
      XCTAssertEqual(error, .countryCodeIncorrectLength)
    }
  }

  func test_validate_validPhone_returnsSuccess() {
    let phone = Phone(number: nil, country: nil)

    switch subject.validate(phone) {
    case .success:
      break
    case .failure(let error):
      XCTFail(error.localizedDescription)
    }
  }
}
