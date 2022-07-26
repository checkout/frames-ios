//
//  PaymentFormFactoryTests.swift
//  
//
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
import Checkout
@testable import Frames

class PaymentFormFactoryTests: XCTestCase {
  func testGetPaymentFormViewController() throws {

    let billingFormStyle = BillingFormFactory.defaultBillingFormStyle
    let paymentFormStyle = BillingFormFactory.defaultPaymentFormStyle
    let address = Address(addressLine1: "Test line1",
                          addressLine2: nil,
                          city: "London",
                          state: "London",
                          zip: "N12345",
                          country: Country(iso3166Alpha2: "GB"))

    let phone = Phone(number: "77 1234 1234",
                      country: Country(iso3166Alpha2: "GB"))
    let name = "User 1"

    let billingForm = BillingForm(name: name, address: address, phone: phone)

    let formConfig = PaymentFormConfiguration(apiKey: "", environment: .sandbox, supportedSchemes: [.visa], billingFormData: billingForm)
    let formStyle = PaymentStyle(paymentFormStyle: paymentFormStyle, billingFormStyle: billingFormStyle)
    let viewController = PaymentFormFactory.buildViewController(configuration: formConfig, style: formStyle)

    XCTAssertNotNil(viewController)

    let paymentViewController = try XCTUnwrap(viewController as? PaymentViewController)

    XCTAssertNotNil(paymentViewController.viewModel)
    XCTAssertNotNil(paymentViewController.viewModel.billingFormData)
    XCTAssertNotNil(paymentViewController.viewModel.billingFormStyle)
    XCTAssertNotNil(paymentViewController.viewModel.paymentFormStyle)
  }

}
