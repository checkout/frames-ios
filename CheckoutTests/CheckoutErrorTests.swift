//
//  CheckoutErrorTests.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

@testable import Checkout
import XCTest
// swiftlint:disable force_unwrapping
final class CheckoutErrorTests: XCTestCase {
  func test_code_returnsCorrectCode() {
    XCTAssertEqual(ValidationError.CardNumber.invalidCharacters.code, 1001)
    XCTAssertEqual(ValidationError.CVV.containsNonDigits.code, 1002)
    XCTAssertEqual(ValidationError.CVV.invalidLength.code, 1003)
    XCTAssertEqual(ValidationError.ExpiryDate.invalidMonthString.code, 1005)
    XCTAssertEqual(ValidationError.ExpiryDate.invalidYearString.code, 1006)
    XCTAssertEqual(ValidationError.ExpiryDate.invalidMonth.code, 1007)
    XCTAssertEqual(ValidationError.ExpiryDate.invalidYear.code, 1008)
    XCTAssertEqual(ValidationError.ExpiryDate.incompleteMonth.code, 1009)
    XCTAssertEqual(ValidationError.ExpiryDate.incompleteYear.code, 1010)
    XCTAssertEqual(ValidationError.ExpiryDate.inThePast.code, 1011)
    XCTAssertEqual(ValidationError.Address.addressLine1IncorrectLength.code, 1012)
    XCTAssertEqual(ValidationError.Address.addressLine2IncorrectLength.code, 1013)
    XCTAssertEqual(ValidationError.Address.invalidCityLength.code, 1014)
    XCTAssertEqual(ValidationError.Address.invalidCountry.code, 1015)
    XCTAssertEqual(ValidationError.Address.invalidStateLength.code, 1016)
    XCTAssertEqual(ValidationError.Address.invalidZipLength.code, 1017)
    XCTAssertEqual(ValidationError.Phone.numberIncorrectLength.code, 1018)
    XCTAssertEqual(ValidationError.Phone.countryCodeIncorrectLength.code, 1019)

    let randomPhoneError = ValidationError.Phone.allCases.randomElement()!
    XCTAssertEqual(ValidationError.Card.phone(randomPhoneError).code, randomPhoneError.code)

    let randomCardNumberError = ValidationError.CardNumber.allCases.randomElement()!
    XCTAssertEqual(ValidationError.Card.cardNumber(randomCardNumberError).code, randomCardNumberError.code)

    let randomCVVError = ValidationError.CVV.allCases.randomElement()!
    XCTAssertEqual(ValidationError.Card.cvv(randomCVVError).code, randomCVVError.code)

    let randomAddressError = ValidationError.Address.allCases.randomElement()!
    XCTAssertEqual(ValidationError.Card.billingAddress(randomAddressError).code, randomAddressError.code)

    XCTAssertEqual(NetworkError.noInternetConnectivity.code, 2000)
    XCTAssertEqual(NetworkError.connectionFailed.code, 2001)
    XCTAssertEqual(NetworkError.connectionTimeout.code, 2002)
    XCTAssertEqual(NetworkError.connectionLost.code, 2003)
    XCTAssertEqual(NetworkError.internationalRoamingOff.code, 2004)
    XCTAssertEqual(NetworkError.unknown(additionalInfo: "", error: nil).code, 2005)
    XCTAssertEqual(NetworkError.certificateTransparencyChecksFailed.code, 2006)
    XCTAssertEqual(NetworkError.couldNotDecodeValues.code, 2007)
    XCTAssertEqual(NetworkError.emptyResponse.code, 2008)

    let serverError = TokenisationError.ServerError(requestID: "", errorType: "", errorCodes: [])
    XCTAssertEqual(serverError.code, 3000)

    XCTAssertEqual(TokenisationError.TokenRequest.serverError(serverError).code, 3000)
    XCTAssertEqual(TokenisationError.TokenRequest.couldNotBuildURLForRequest.code, 3001)
      
    XCTAssertEqual(TokenisationError.TokenRequest.missingAPIKey.code, 4000)

    XCTAssertEqual(
      TokenisationError.TokenRequest.cardValidationError(.phone(randomPhoneError)).code,
      randomPhoneError.code
    )
    XCTAssertEqual(
      TokenisationError.TokenRequest.cardValidationError(.cardNumber(randomCardNumberError)).code,
      randomCardNumberError.code
    )
    XCTAssertEqual(
      TokenisationError.TokenRequest.cardValidationError(.cvv(randomCVVError)).code,
      randomCVVError.code
    )
    XCTAssertEqual(
      TokenisationError.TokenRequest.cardValidationError(.billingAddress(randomAddressError)).code,
      randomAddressError.code
    )
  }
}
