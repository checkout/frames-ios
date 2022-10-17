//
//  AddressValidatorTests.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

@testable import Checkout
import XCTest
// swiftlint:disable force_unwrapping
final class AddressValidatorTests: XCTestCase {
  private let subject = AddressValidator()

  func test_validate_addressLine1TooLong_returnsFailure() {
    let addressLine1 = String((0..<Constants.Address.addressLine1Length + 1).map { _ in "0123456789".randomElement()! })

    let address = Address(addressLine1: addressLine1, addressLine2: nil, city: nil, state: nil, zip: nil, country: nil)

    assert(address, expectedAddressError: .addressLine1IncorrectLength)
  }

  func test_validate_addressLine2TooLong_returnsFailure() {
    let addressLine2 = String((0..<Constants.Address.addressLine2Length + 1).map { _ in "0123456789".randomElement()! })

    let address = Address(addressLine1: nil, addressLine2: addressLine2, city: nil, state: nil, zip: nil, country: nil)

    assert(address, expectedAddressError: .addressLine2IncorrectLength)
  }

  func test_validate_cityTooLong_returnsFailure() {
    let city = String((0..<Constants.Address.cityLength + 1).map { _ in "0123456789".randomElement()! })

    let address = Address(addressLine1: nil, addressLine2: nil, city: city, state: nil, zip: nil, country: nil)

    assert(address, expectedAddressError: .invalidCityLength)
  }

  func test_validate_stateTooLong_returnsFailure() {
    let state = String((0..<Constants.Address.stateLength + 1).map { _ in "0123456789".randomElement()! })

    let address = Address(addressLine1: nil, addressLine2: nil, city: nil, state: state, zip: nil, country: nil)

    assert(address, expectedAddressError: .invalidStateLength)
  }

  func test_validate_zipTooLong_returnsFailure() {
    let zip = String((0..<Constants.Address.zipLength + 1).map { _ in "0123456789".randomElement()! })

    let address = Address(addressLine1: nil, addressLine2: nil, city: nil, state: nil, zip: zip, country: nil)

    assert(address, expectedAddressError: .invalidZipLength)
  }

  func test_validate_validAddress_returnsSuccess() {
    let address = Address(addressLine1: nil, addressLine2: nil, city: nil, state: nil, zip: nil, country: nil)

    switch subject.validate(address) {
    case .success:
      break
    case .failure(let addressError):
      XCTFail(addressError.localizedDescription)
    }
  }

  // MARK: - Private

  private func assert(_ address: Address, expectedAddressError: ValidationError.Address) {
    switch subject.validate(address) {
    case .success:
      XCTFail("Unexpected success.")
    case .failure(let addressError):
      XCTAssertEqual(addressError, expectedAddressError)
    }
  }
}
