//
//  CardValidatorTests.swift
//
//
//  Created by Harry Brown on 21/10/2021.
//

import XCTest
@testable import Checkout
// swiftlint:disable force_unwrapping implicitly_unwrapped_optional file_length
class CardValidatorTests: XCTestCase {
  private var subject: CardValidator!
  private let stubCalendar = StubCalendar()
  private let stubCardNumberValidator = StubCardNumberValidator()
  private let stubPhoneValidator = StubPhoneValidator()
  private let stubAddressValidator = StubAddressValidator()
  private let stubCVVValidator = StubCVVValidator()
  private let stubLogManager = StubLogManager.self

  override func setUp() {
    super.setUp()

    subject = CardValidator(
      cardNumberValidator: stubCardNumberValidator,
      addressValidator: stubAddressValidator,
      phoneValidator: stubPhoneValidator,
      cvvValidator: stubCVVValidator,
      calendar: stubCalendar,
      logManager: stubLogManager)
  }
}

// MARK: - Log on init
extension CardValidatorTests {
  func test_logOnInit() {
    XCTAssertEqual(stubLogManager.queueCalledWith.last, .cardValidator)
  }
}

// MARK: - Validate Card Number
extension CardValidatorTests {
  func test_cardNumber_logWhenCalled() {
    _ = subject.validate(cardNumber: "stub_cardNumber")

    XCTAssertEqual(stubLogManager.queueCalledWith.last, .validateCardNumber)
  }

  func test_cardNumber_cardNumberValidatorReturnsSuccess_returnsSuccess() {
    let cardScheme = Card.Scheme.allCases.randomElement()!
    stubCardNumberValidator.validateCardNumberToReturn = .success(cardScheme)

    let result = subject.validate(cardNumber: "stub_cardNumber")
    let resultScheme: Card.Scheme!

    switch result {
    case .success(let scheme):
      resultScheme = scheme
    case .failure(let error):
      return XCTFail(error.localizedDescription)
    }

    XCTAssertEqual(stubCardNumberValidator.validateCardNumberCalledWith, "stub_cardNumber")
    XCTAssertEqual(resultScheme, cardScheme)
  }

  func test_cardNumber_cardNumberValidatorReturnsError_returnsSuccess() {
    let randomError = ValidationError.CardNumber.allCases.randomElement()!
    stubCardNumberValidator.validateCardNumberToReturn = .failure(randomError)

    let result = subject.validate(cardNumber: "stub_cardNumber")
    let resultError: ValidationError.CardNumber!

    switch result {
    case .success:
      return XCTFail("Unexpected successful card scheme validation.")
    case .failure(let error):
      resultError = error
    }

    XCTAssertEqual(stubCardNumberValidator.validateCardNumberCalledWith, "stub_cardNumber")
    XCTAssertEqual(resultError, randomError)
  }
}

// MARK: - Validate Expiry Date
extension CardValidatorTests {
  func test_validate_expiryMonthYearString_logWhenCalled() {
    test_validate(
      expiryMonth: "abc123",
      expiryYear: "22",
      expectedResult: .failure(.invalidMonthString))

    XCTAssertEqual(stubLogManager.queueCalledWith.last, .validateExpiryString)
  }

  func test_validate_expiryMonthYearString_invalidMonth_returnsError() {
    test_validate(
      expiryMonth: "abc123",
      expiryYear: "22",
      expectedResult: .failure(.invalidMonthString))

    test_validate(
      expiryMonth: "",
      expiryYear: "22",
      expectedResult: .failure(.invalidMonthString))
  }

  func test_validate_expiryMonthYearString_invalidMonthNumber_returnsError() {
    test_validate(
      expiryMonth: "-5",
      expiryYear: "22",
      expectedResult: .failure(.invalidMonth))

    test_validate(
      expiryMonth: "13",
      expiryYear: "22",
      expectedResult: .failure(.invalidMonth))
  }

  func test_validate_expiryMonthYearString_invalidYear_returnsError() {
    test_validate(
      expiryMonth: "11",
      expiryYear: "",
      expectedResult: .failure(.invalidYearString))

    test_validate(
      expiryMonth: "11",
      expiryYear: "22abc",
      expectedResult: .failure(.invalidYearString))
  }

  func test_validate_expiryMonthYearString_incompleteYear_returnsError() {
    test_validate(
      expiryMonth: "11",
      expiryYear: "2",
      expectedResult: .failure(.incompleteYear))

    test_validate(
      expiryMonth: "11",
      expiryYear: "202",
      expectedResult: .failure(.incompleteYear))
  }

  func test_validate_expiryMonthYearString_yearTooLong_returnsError() {
    test_validate(
      expiryMonth: "11",
      expiryYear: "20241",
      expectedResult: .failure(.invalidYear))

    test_validate(
      expiryMonth: "11",
      expiryYear: "202412",
      expectedResult: .failure(.invalidYear))
  }

  func test_validate_expiryMonthYearString_calendarCalledCorrectly() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"

    stubCalendar.dateFromComponentsToReturn = formatter.date(from: "2099/10/01 00:00")

    test_validate(
      expiryMonth: "11",
      expiryYear: "2021",
      expectedResult: .success(ExpiryDate(month: 11, year: 2021)))

    let dateComponents2040 = stubCalendar.dateFromComponentsCalledWith
    XCTAssertEqual(dateComponents2040?.month, 11)
    XCTAssertEqual(dateComponents2040?.year, 2021)

    test_validate(
      expiryMonth: "11",
      expiryYear: "2021",
      expectedResult: .success(ExpiryDate(month: 11, year: 2021)))

    let dateComponents40 = stubCalendar.dateFromComponentsCalledWith
    XCTAssertEqual(dateComponents40?.month, 11)
    XCTAssertEqual(dateComponents40?.year, 2021)
  }

  
  func test_validate_expiryMonthYearString_providedDateInThePast_CurrentYear_returnsCorrectError() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"

    stubCalendar.dateFromComponentsToReturn = formatter.date(from: "2020/10/01 00:00")

    test_validate(
      expiryMonth: "01",
      expiryYear: "2023",
      expectedResult: .failure(.inThePast))
  }
  
  func test_validate_expiryMonthYearString_providedDateInThePast_returnsCorrectError() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"

    stubCalendar.dateFromComponentsToReturn = formatter.date(from: "2020/10/01 00:00")

    test_validate(
      expiryMonth: "11",
      expiryYear: "2040",
      expectedResult: .failure(.inThePast))
  }

  func test_validate_expiryMonthYearString_calendarDateReturnsNil_returnsCorrectError() {
    stubCalendar.dateFromComponentsToReturn = nil
    test_validate(
      expiryMonth: "11",
      expiryYear: "2040",
      expectedResult: .failure(.inThePast))
  }

  func test_validate_expiryMonthYearInt_logWhenCalled() {
    test_validate(
      expiryMonth: -5,
      expiryYear: 22,
      expectedResult: .failure(.invalidMonth))

    XCTAssertEqual(stubLogManager.queueCalledWith.last, .validateExpiryInteger)
  }

  func test_validate_expiryMonthYearInt_invalidMonthNumber_returnsError() {
    test_validate(
      expiryMonth: -5,
      expiryYear: 22,
      expectedResult: .failure(.invalidMonth))

    test_validate(
      expiryMonth: 13,
      expiryYear: 22,
      expectedResult: .failure(.invalidMonth))
  }

  func test_validate_expiryMonthYearInt_incompleteYear_returnsError() {
    test_validate(
      expiryMonth: 11,
      expiryYear: 2,
      expectedResult: .failure(.incompleteYear))

    test_validate(
      expiryMonth: 11,
      expiryYear: 202,
      expectedResult: .failure(.incompleteYear))
  }

  func test_validate_expiryMonthYearInt_yearTooLong_returnsError() {
    test_validate(
      expiryMonth: 11,
      expiryYear: 20241,
      expectedResult: .failure(.invalidYear))

    test_validate(
      expiryMonth: 11,
      expiryYear: 202412,
      expectedResult: .failure(.invalidYear))
  }

  func test_validate_expiryMonthYearInt_calendarCalledCorrectly() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"

    stubCalendar.dateFromComponentsToReturn = formatter.date(from: "2099/10/01 00:00")

    test_validate(
      expiryMonth: 11,
      expiryYear: 2040,
      expectedResult: .success(ExpiryDate(month: 11, year: 2040)))

    let dateComponents2040 = stubCalendar.dateFromComponentsCalledWith
    XCTAssertEqual(dateComponents2040?.month, 11)
    XCTAssertEqual(dateComponents2040?.year, 2040)

    test_validate(
      expiryMonth: 11,
      expiryYear: 40,
      expectedResult: .success(ExpiryDate(month: 11, year: 2040)))

    let dateComponents40 = stubCalendar.dateFromComponentsCalledWith
    XCTAssertEqual(dateComponents40?.month, 11)
    XCTAssertEqual(dateComponents40?.year, 2040)
  }

  // MARK: Private

  private func test_validate(
    expiryMonth: String,
    expiryYear: String,
    expectedResult: Result<ExpiryDate, ValidationError.ExpiryDate>
  ) {
    let result = subject.validate(
      expiryMonth: expiryMonth,
      expiryYear: expiryYear)

    switch result {
    case .success(let expiryDate):

      switch expectedResult {
      case .success(let expectedExpiryDate):
        XCTAssertEqual(expiryDate, expectedExpiryDate)
      case .failure(let error):
        XCTFail(error.localizedDescription)
      }

    case .failure(let error):

      switch expectedResult {
      case .success(let expiryDate):
        XCTFail("Unexpected successful expiry date validation: \(expiryDate).")
      case .failure(let expectedError):
        XCTAssertEqual(expectedError, error)
      }
    }
  }

  private func test_validate(
    expiryMonth: Int,
    expiryYear: Int,
    expectedResult: Result<ExpiryDate, ValidationError.ExpiryDate>
  ) {
    let result = subject.validate(
      expiryMonth: expiryMonth,
      expiryYear: expiryYear)

    XCTAssertEqual(result, expectedResult)
  }
}

// MARK: - Validate CVV
extension CardValidatorTests {
  func test_validateCVV_logWhenCalled() {
    _ = subject.validate(cvv: "100")

    XCTAssertEqual(stubLogManager.queueCalledWith.last, .validateCVV)
  }

  func test_validateCVV_cvvValidatorReturnsError_returnsSameError() {
    let randomError = ValidationError.CVV.allCases.randomElement()!
    stubCVVValidator.validateToReturn = .failure(randomError)
    let randomScheme = Card.Scheme.allCases.randomElement()!

    let result = subject.validate(
      cvv: "12a",
      cardScheme: randomScheme)

    switch result {
    case .success:
      XCTFail("Unexpected successful CVV validation.")
    case .failure(let error):
      XCTAssertEqual(stubCVVValidator.validateCalledWith?.cvv, "12a")
      XCTAssertEqual(stubCVVValidator.validateCalledWith?.cardScheme, randomScheme)
      XCTAssertEqual(error, randomError)
    }
  }

  func test_validateCVV_cvvValidatorReturnsSuccess_returnsSameError() {
    stubCVVValidator.validateToReturn = .success

    let result = subject.validate(
      cvv: "12a",
      cardScheme: Card.Scheme.allCases.randomElement()!)

    switch result {
    case .success:
      break
    case .failure(let error):
      XCTFail(error.localizedDescription)
    }
  }
}

// MARK: - Card
extension CardValidatorTests {
  func test_validateCard_cardNumberValidatorReturnsError_returnsCorrectError() {
    let randomError = ValidationError.CardNumber.allCases.randomElement()!
    stubCardNumberValidator.validateCardNumberToReturn = .failure(randomError)

    let card = Card(
      number: "",
      expiryDate: .init(month: 0, year: 0),
      name: nil,
      cvv: nil,
      billingAddress: nil,
      phone: nil
    )

    switch subject.validate(card) {
    case .success:
      XCTFail("Unexpected success.")
    case .failure(let error):
      XCTAssertEqual(error, .cardNumber(randomError))
    }
  }

  func test_validateCard_cvvValidatorReturnsError_returnsCorrectError() {
    let randomError = ValidationError.CVV.allCases.randomElement()!
    stubCVVValidator.validateToReturn = .failure(randomError)

    let randomScheme = Card.Scheme.allCases.randomElement()!
    stubCardNumberValidator.validateCardNumberToReturn = .success(randomScheme)
    let card = Card(
      number: "",
      expiryDate: .init(month: 0, year: 0),
      name: nil,
      cvv: "678",
      billingAddress: nil,
      phone: nil
    )

    switch subject.validate(card) {
    case .success:
      XCTFail("Unexpected success.")
    case .failure(let error):
      XCTAssertEqual(stubCVVValidator.validateCalledWith?.cvv, "678")
      XCTAssertEqual(stubCVVValidator.validateCalledWith?.cardScheme, randomScheme)
      XCTAssertEqual(error, .cvv(randomError))
    }
  }

  func test_validateCard_addressValidatorReturnsError_returnsCorrectError() {
    let randomError = ValidationError.Address.allCases.randomElement()!
    stubAddressValidator.validateToReturn = .failure(randomError)

    let billingAddress = Address(
      addressLine1: "stub1",
      addressLine2: "stub2",
      city: nil,
      state: nil,
      zip: nil,
      country: nil)

    let card = Card(
      number: "",
      expiryDate: .init(month: 0, year: 0),
      name: nil,
      cvv: nil,
      billingAddress: billingAddress,
      phone: nil)

    switch subject.validate(card) {
    case .success:
      XCTFail("Unexpected success.")
    case .failure(let error):
      XCTAssertEqual(stubAddressValidator.validateCalledWith, billingAddress)
      XCTAssertEqual(error, .billingAddress(randomError))
    }
  }

  func test_validateCard_phoneValidatorReturnsError_returnsCorrectError() {
    let randomError = ValidationError.Phone.allCases.randomElement()!
    stubPhoneValidator.validateToReturn = .failure(randomError)

    let phone = Phone(number: "123", country: Country.allAvailable.randomElement()!)
    let card = Card(
      number: "",
      expiryDate: .init(month: 0, year: 0),
      name: nil,
      cvv: nil,
      billingAddress: nil,
      phone: phone
    )

    switch subject.validate(card) {
    case .success:
      XCTFail("Unexpected success.")
    case .failure(let error):
      XCTAssertEqual(stubPhoneValidator.validateCalledWith, phone)
      XCTAssertEqual(error, .phone(randomError))
    }
  }

  func test_validateCard_validCard_returnsSuccess() {
    stubCardNumberValidator.validateCardNumberToReturn = .success(.americanExpress)
    stubCVVValidator.validateToReturn = .success
    stubAddressValidator.validateToReturn = .success
    stubPhoneValidator.validateToReturn = .success

    let billingAddress = Address(
      addressLine1: "stub1",
      addressLine2: "stub2",
      city: nil,
      state: nil,
      zip: nil,
      country: nil
    )
    let phone = Phone(number: "123", country: Country.allAvailable.randomElement()!)

    let card = Card(
      number: "",
      expiryDate: .init(month: 0, year: 0),
      name: nil,
      cvv: "12a",
      billingAddress: billingAddress,
      phone: phone
    )

    switch subject.validate(card) {
    case .success:
      break
    case .failure(let error):
      XCTFail(error.localizedDescription)
    }
  }
}
